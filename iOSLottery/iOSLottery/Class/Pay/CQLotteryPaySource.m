//
//  CQLotteryPaySource.m
//  caiqr
//
//  Created by 彩球 on 16/7/4.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CQLotteryPaySource.h"
#import "CLPayAccountInfo.h"
#import "CLLotteryAccountAndThirdPayAPI.h"
#import "CLLotteryOnlyThirdPayAPI.h"
#import "CLLoadingAnimationView.h"

@interface CQLotteryPaySource () <CLRequestCallBackDelegate>

@property (nonatomic, strong) CLLotteryAccountAndThirdPayAPI* accountAndThirdPayAPI;
@property (nonatomic, strong) CLLotteryOnlyThirdPayAPI* onlyThirdAPI;

@end

@implementation CQLotteryPaySource

- (void)runPayment
{
    /** 如果仅红包支付或仅余额支付 */
    if (self.channel_type == paymentChannelTypeOnlyRedParkets ||
        self.channel_type == paymentChannelTypeAccountBalance)
    {
        
        NSDictionary* parameter = [CQSportsBetPaymentHandler parameterTotalAccount:self.total_amount payAccount:self.need_pay_amount redAccount:self.redPa_amount hasRedPacket:self.has_redPacket redProgramsId:self.has_redPacket ? self.redPa_program_id : nil flowId:self.flow_id payForToken:nil redOrderId:nil];
        [CQSportsBetPaymentHandler sportsBetPaymentGotoSafariWithPaymentInfo:parameter
                                                              transitionType:transitionTypeTicketPayment
                                                          paymentChannelType:self.channel_type
                                                paymentChannelConfigH5String:self.url_prefix
                                                              viewController:self.launch_class];
        if (self.didOpenSafari) self.didOpenSafari();
    }
    else if (self.channel_type != paymentChannelTypeOther)
    {   //银联 连连 易宝
        //** 判断是否有红包 */
        //** 红包支付 */
        
        if (self.has_redPacket)
        {
            self.accountAndThirdPayAPI.pre_handle_token = self.flow_id;
            self.accountAndThirdPayAPI.amount = self.total_amount;
            self.accountAndThirdPayAPI.fid = self.redPa_program_id;
            self.accountAndThirdPayAPI.red_amount = self.redPa_amount;
            self.accountAndThirdPayAPI.account_type_id = [NSString stringWithFormat:@"%zi",self.channel_type];
            self.accountAndThirdPayAPI.account_amount = [NSString stringWithFormat:@"%lld",[self.total_amount longLongValue] - [self.redPa_amount longLongValue]];
            self.accountAndThirdPayAPI.card_no = self.card_no;
            [[CLLoadingAnimationView shareLoadingAnimationView] showLoadingAnimationInCurrentViewControllerWithType:CLLoadingAnimationTypeNormal];
            [self.accountAndThirdPayAPI start];
        }
        else
        {
            self.onlyThirdAPI.pre_handle_token = self.flow_id;
            self.onlyThirdAPI.amount = self.total_amount;
            self.onlyThirdAPI.account_type_id = [NSString stringWithFormat:@"%zi",self.channel_type];
            self.onlyThirdAPI.card_no = self.card_no;
            [[CLLoadingAnimationView shareLoadingAnimationView] showLoadingAnimationInCurrentViewControllerWithType:CLLoadingAnimationTypeNormal];
            [self.onlyThirdAPI start];
        }
    }


}

#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    
    [[CLLoadingAnimationView shareLoadingAnimationView] stop];
    if (request.urlResponse.success) {
        [self userPayOrderWithRedPacketsOrBalanceOrThirdPayMentWithObj:[request.urlResponse.resp firstObject]];
    } else {
        !(self.createPayForToken)?nil:self.createPayForToken(NO,request.urlResponse.errorMessage);
    }
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    [[CLLoadingAnimationView shareLoadingAnimationView] stop];
    !(self.createPayForToken)?nil:self.createPayForToken(NO,request.urlResponse.error);
}

/** 三方支付回调 */
- (void)userPayOrderWithRedPacketsOrBalanceOrThirdPayMentWithObj:(id)obj
{
    CLPayAccountInfo *payInfo = [CLPayAccountInfo mj_objectWithKeyValues:obj];
    
    if (!payInfo) {
        if (self.createPayForToken)
            self.createPayForToken(NO,@"支付异常");
    }
    
    /** 支付方式 */
    //    sportPaymentChannelType sportChannel = channelFromAccountType(self.paymentChannelType);
    NSDictionary* parameter = [CQSportsBetPaymentHandler parameterTotalAccount:self.total_amount
                                                                    payAccount:self.need_pay_amount
                                                                    redAccount:self.redPa_amount
                                                                  hasRedPacket:self.has_redPacket
                                                                 redProgramsId:self.redPa_program_id
                                                                        flowId:payInfo.flow_id
                                                                   payForToken:payInfo.pay_for_token
                                                                    redOrderId:nil];
    /** 跳转H5 */
    [CQSportsBetPaymentHandler sportsBetPaymentGotoSafariWithPaymentInfo:parameter
                                                          transitionType:self.transitionType
                                                      paymentChannelType:self.channel_type
                                            paymentChannelConfigH5String:self.url_prefix
                                                          viewController:self.launch_class];
    /** 跳转回调 */
    if (self.didOpenSafari) self.didOpenSafari();
}


- (void)paymentFinishCheck
{
    if (!self.flow_id) return;
    
    //[CQNetsAPIListService sportBet_PayOrderAfterMakeSureWithAmount:self.total_amount flowId:self.flow_id accountTypeId:[NSString stringWithFormat:@"%zi",self.channel_type] response:nil];
}

- (CLLotteryAccountAndThirdPayAPI*)accountAndThirdPayAPI {
    if (!_accountAndThirdPayAPI) {
        _accountAndThirdPayAPI = [[CLLotteryAccountAndThirdPayAPI alloc] init];
        _accountAndThirdPayAPI.delegate = self;
    }
    return _accountAndThirdPayAPI;
}

- (CLLotteryOnlyThirdPayAPI *)onlyThirdAPI {
    
    if (!_onlyThirdAPI) {
        _onlyThirdAPI = [[CLLotteryOnlyThirdPayAPI alloc] init];
        _onlyThirdAPI.delegate = self;
    }
    return _onlyThirdAPI;
}

@end
