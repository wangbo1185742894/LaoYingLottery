//
//  CQLotteryPaySource.m
//  caiqr
//
//  Created by 彩球 on 16/7/4.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CKLotteryPaySource.h"
//#import "CQNetsAPIList.h"
#import "CKUserPayMentInfo.h"
//#import "CQWXPaymentManager.h"
#import "CKLotteryAccountAndThirdPayAPI.h"
#import "CKLotteryOnlyThirdPayAPI.h"
#import "CKPayClient.h"
@interface CKLotteryPaySource () <CLRequestCallBackDelegate>

@property (nonatomic, strong) CKLotteryAccountAndThirdPayAPI* accountAndThirdPayAPI;
@property (nonatomic, strong) CKLotteryOnlyThirdPayAPI* onlyThirdAPI;

@end

@implementation CKLotteryPaySource

- (void)runPayment
{
    
    /** 如果仅红包支付或仅余额支付 */
    if (self.channel_type == CKPaymentChannelTypeOnlyRedParkets ||
        self.channel_type == CKPaymentChannelTypeAccountBalance)
    {
        
        NSDictionary* parameter = [CKSportsBetPaymentHandler parameterTotalAccount:self.total_amount payAccount:self.need_pay_amount redAccount:self.redPa_amount hasRedPacket:self.has_redPacket redProgramsId:self.has_redPacket ? self.redPa_program_id : nil flowId:self.flow_id payForToken:nil redOrderId:nil];
//        [CQSportsBetPaymentHandler sportsBetPaymentGotoSafariWithPaymentInfo:parameter
//                                                              transitionType:transitionTypeTicketPayment
//                                                          paymentChannelType:self.channel_type
//                                                paymentChannelConfigH5String:self.url_prefix
//                                                              viewController:self.launch_class];
        
        
        //将H5支付参数进行回调
        (!self.callBackH5Pay)?:self.callBackH5Pay(parameter);
//        if (self.didOpenSafari) self.didOpenSafari();
    }
    else if (self.channel_type != CKPaymentChannelTypeOther)
    {   //银联 连连 易宝
        //** 判断是否有红包 */
        //** 红包支付 */
        
        self.startNativeRequest?self.startNativeRequest():nil;
        
        if (self.has_redPacket)
        {
            
            self.accountAndThirdPayAPI.pre_handle_token = self.flow_id;
            self.accountAndThirdPayAPI.amount = self.total_amount;
            self.accountAndThirdPayAPI.fid = self.redPa_program_id;
            self.accountAndThirdPayAPI.red_amount = self.redPa_amount;
            self.accountAndThirdPayAPI.account_type_id = [NSString stringWithFormat:@"%zi",self.channel_type];
            self.accountAndThirdPayAPI.account_amount = [NSString stringWithFormat:@"%lld",[self.total_amount longLongValue] - [self.redPa_amount longLongValue]];
            self.accountAndThirdPayAPI.card_no = self.card_no;
            [[CKPayClient sharedManager].intermediary startLoading];
            [self.accountAndThirdPayAPI start];
            
        }
        else
        {
            
            self.onlyThirdAPI.pre_handle_token = self.flow_id;
            self.onlyThirdAPI.amount = self.total_amount;
            self.onlyThirdAPI.account_type_id = [NSString stringWithFormat:@"%zi",self.channel_type];
            self.onlyThirdAPI.card_no = self.card_no;
            [[CKPayClient sharedManager].intermediary startLoading];
            [self.onlyThirdAPI start];
        }
    }
}

#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    [[CKPayClient sharedManager].intermediary stopLoading];
    if (request.urlResponse.success) {
        [self userPayOrderWithRedPacketsOrBalanceOrThirdPayMentWithObj:[request.urlResponse.resp firstObject]];
    } else {
        (!self.endNativeRequest)?:self.endNativeRequest(NO,request.urlResponse.errorMessage);
    }
}

- (void)requestFailed:(CLBaseRequest *)request {
    [[CKPayClient sharedManager].intermediary stopLoading];
    (!self.endNativeRequest)?:self.endNativeRequest(NO,request.urlResponse.errorMessage);
}

#pragma mark - finish operation

/** 三方支付回调 */
- (void)userPayOrderWithRedPacketsOrBalanceOrThirdPayMentWithObj:(id)obj
{
    CKUserPayAccountInfo *payInfo = [CKUserPayAccountInfo objectWithKeyValues:obj];
    
    if (!payInfo) {
        (!self.endNativeRequest)?:self.endNativeRequest(NO,@"支付异常");
    } else {
        (!self.endNativeRequest)?:self.endNativeRequest(YES,@"");
    }

    
    /** 支付方式 */
    //    sportPaymentChannelType sportChannel = channelFromAccountType(self.paymentChannelType);
    NSDictionary* parameter = [CKSportsBetPaymentHandler parameterTotalAccount:self.total_amount
                                                                    payAccount:self.need_pay_amount
                                                                    redAccount:self.redPa_amount
                                                                  hasRedPacket:self.has_redPacket
                                                                 redProgramsId:self.redPa_program_id
                                                                        flowId:payInfo.flow_id
                                                                   payForToken:payInfo.pay_for_token
                                                                    redOrderId:nil];
    
    
    (!self.callBackSDKPay)?:self.callBackSDKPay(payInfo.pay_channel_key,payInfo.pay_for_token,parameter);
    
}


- (void)paymentFinishCheck
{
//    if (!self.flow_id) return;
//    
//    [CQNetsAPIListService sportBet_PayOrderAfterMakeSureWithAmount:self.total_amount flowId:self.flow_id accountTypeId:[NSString stringWithFormat:@"%zi",self.channel_type] response:nil];
}

- (CKLotteryAccountAndThirdPayAPI*)accountAndThirdPayAPI {
    if (!_accountAndThirdPayAPI) {
        _accountAndThirdPayAPI = [[CKLotteryAccountAndThirdPayAPI alloc] init];
        _accountAndThirdPayAPI.delegate = self;
    }
    return _accountAndThirdPayAPI;
}

- (CKLotteryOnlyThirdPayAPI *)onlyThirdAPI {
    
    if (!_onlyThirdAPI) {
        _onlyThirdAPI = [[CKLotteryOnlyThirdPayAPI alloc] init];
        _onlyThirdAPI.delegate = self;
    }
    return _onlyThirdAPI;
}


@end
