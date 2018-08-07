//
//  CQCashDepositPaySource.m
//  caiqr
//
//  Created by 彩球 on 16/7/4.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CQCashDepositPaySource.h"
#import "CQDefinition.h"
#import "CQPayOrderInfo.h"
#import "CLRechargeOrderCreateAPI.h"
#import "CLLoadingAnimationView.h"
#import "CLShowHUDManager.h"
@interface CQCashDepositPaySource () <CLRequestCallBackDelegate>

@property (nonatomic, strong) CLRechargeOrderCreateAPI* orderCreateAPI;

@end

@implementation CQCashDepositPaySource

- (void)runPayment
{
    
    self.orderCreateAPI.amount = self.total_amount;
    self.orderCreateAPI.need_channels = [NSString stringWithFormat:@"%zi",self.channel_type];
    self.orderCreateAPI.trading_infos = [self.pay_trading_info mj_JSONString];
    self.orderCreateAPI.card_no = self.card_no;
    [[CLLoadingAnimationView shareLoadingAnimationView] showLoadingAnimationInCurrentViewControllerWithType:CLLoadingAnimationTypeNormal];
    [self.orderCreateAPI start];
}

#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    
    [[CLLoadingAnimationView shareLoadingAnimationView] stop];
    if (request.urlResponse.success) {
        [self userAccountCreateDepositOrederWithInfo:[request.urlResponse.resp firstObject]];
    } else {
        (self.createPayForToken)?nil:self.createPayForToken(NO,request.urlResponse.errorMessage);
    }
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    [[CLLoadingAnimationView shareLoadingAnimationView] stop];
    (self.createPayForToken)?nil:self.createPayForToken(NO,request.urlResponse.error);
    [CLShowHUDManager showInWindowWithText:request.urlResponse.errorMessage type:CLShowHUDTypeOnlyText delayTime:1.f];
}
/** 银联跳转safari进行支付 */
- (void)userAccountCreateDepositOrederWithInfo:(id)obj
{
    CQRechagreInfo* info = [CQRechagreInfo mj_objectWithKeyValues:obj];
    if (!info){
        if (self.createPayForToken)
            self.createPayForToken(NO,@"支付异常");
        
        return;
    }
    
    if (self.createPayForToken)
        self.createPayForToken(YES,info);
    
    self.order_id = info.order_info.order_id;
    
    //** 创建充值订单后，充值信息 */
//    NSLog(@"+++++充值订单ID%@，充值金额：%lld，充值方式：%zi",info.order_info.order_id,_desPositNumber,self.mainDataSource[_selectedDespositIndex].account_type_id);
 
    if (info.pay_for_tokens && info.pay_for_tokens.count > 0) {
        CQPayToken* payToken = info.pay_for_tokens.firstObject;
        
        self.flow_id = payToken.flow_id;
        
        if (payToken && payToken.pay_for_token) {
            NSDictionary* parameter = [CQSportsBetPaymentHandler parameterTotalAccount:self.total_amount
                                                                            payAccount:self.need_pay_amount
                                                                            redAccount:@"0"
                                                                          hasRedPacket:NO
                                                                         redProgramsId:nil
                                                                                flowId:payToken.flow_id
                                                                           payForToken:payToken.pay_for_token
                                                                            redOrderId:nil];
            if (self.willOpenSafari) {
                self.willOpenSafari();
            }
            
            if (self.channel_type == paymentChannelTypeAliPay && payToken.pay_for_token.length > 0) {
                NSDictionary* dict = [payToken.pay_for_token mj_JSONObject];
                NSString* url = dict[@"url"];
                if ([url isKindOfClass:NSString.class] && [url hasPrefix:@"http"]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                }
                /** 跳出block回调 */
                if (self.didOpenSafari) {
                    self.didOpenSafari();
                }
                return;
            }
            
            
            [CQSportsBetPaymentHandler sportsBetPaymentGotoSafariWithPaymentInfo:parameter
                                                                  transitionType:self.transitionType paymentChannelType:self.channel_type paymentChannelConfigH5String:self.url_prefix
                                                                  viewController:self.launch_class];
            if (self.didOpenSafari) {
                self.didOpenSafari();
            }
        } else {
            if (self.createPayForToken)
                self.createPayForToken(NO,@"暂时无法支付");
        }
    }
}


- (void)paymentFinishCheck
{
    if (!self.flow_id || !self.order_id) {
        return;
    }
    
//    NSArray* arr = @[@{@"flow_id":self.flow_id}];
    //[CQNetsAPIListService userRelate_UserUpdateRechargeOrderAmount:self.total_amount order_id:self.order_id trading_infos:arr response:nil];
}

- (CLRechargeOrderCreateAPI *)orderCreateAPI {
    
    if (!_orderCreateAPI) {
        _orderCreateAPI = [[CLRechargeOrderCreateAPI alloc] init];
        _orderCreateAPI.delegate = self;
    }
    return _orderCreateAPI;
}

@end
