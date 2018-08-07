//
//  CQCashDepositPaySource.m
//  caiqr
//
//  Created by 彩球 on 16/7/4.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CKCashDepositPaySource.h"
#import "CKPayOrderInfo.h"
#import "CKRechargeOrderCreateAPI.h"
#import "MJExtension.h"
#import "CKPayClient.h"
@interface CKCashDepositPaySource () <CLRequestCallBackDelegate>

@property (nonatomic, strong) CKRechargeOrderCreateAPI* orderCreateAPI;

@end

@implementation CKCashDepositPaySource

- (void)runPayment
{
    
    (!self.startNativeRequest)?:self.startNativeRequest();
    self.orderCreateAPI.amount = self.total_amount;
    self.orderCreateAPI.need_channels = [NSString stringWithFormat:@"%zi",self.channel_type];
    self.orderCreateAPI.trading_infos = [self.pay_trading_info JSONString];
    self.orderCreateAPI.card_no = self.card_no;
    [[CKPayClient sharedManager].intermediary startLoading];
    [self.orderCreateAPI start];
    
}
#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    [[CKPayClient sharedManager].intermediary stopLoading];
    if (request.urlResponse.success) {
        [self userAccountCreateDepositOrederWithInfo:[request.urlResponse.resp firstObject]];
    } else {
        (!self.endNativeRequest)?:self.endNativeRequest(NO,request.urlResponse.errorMessage);
    }
}

- (void)requestFailed:(CLBaseRequest *)request {
    [[CKPayClient sharedManager].intermediary stopLoading];
    (!self.endNativeRequest)?:self.endNativeRequest(NO,request.urlResponse.error);
}

/** 银联跳转safari进行支付 */
- (void)userAccountCreateDepositOrederWithInfo:(id)obj
{
    CKRechagreInfo* info = [CKRechagreInfo objectWithKeyValues:obj];
    if (!info){
       (!self.endNativeRequest)?:self.endNativeRequest(NO,@"支付异常");
        return;
    }
    
    self.order_id = info.order_info.order_id;
 
    if (info.pay_for_tokens && info.pay_for_tokens.count > 0) {
        
        (!self.endNativeRequest)?:self.endNativeRequest(YES,@"");
        CKPayToken* payToken = info.pay_for_tokens.firstObject;
        
        self.flow_id = payToken.flow_id;
        
        if (payToken && payToken.pay_for_token) {
            NSDictionary* parameter = [CKSportsBetPaymentHandler parameterTotalAccount:self.total_amount
                                                                            payAccount:self.need_pay_amount
                                                                            redAccount:@"0"
                                                                          hasRedPacket:NO
                                                                         redProgramsId:nil
                                                                                flowId:payToken.flow_id
                                                                           payForToken:payToken.pay_for_token
                                                                            redOrderId:nil];
            
            
             (!self.callBackSDKPay)?:self.callBackSDKPay(info.pay_channel_key,payToken.pay_for_token,parameter);
            
        } else {
             (!self.endNativeRequest)?:self.endNativeRequest(NO,@"暂时无法支付");
        }
    }
}


- (CKRechargeOrderCreateAPI *)orderCreateAPI {
    
    if (!_orderCreateAPI) {
        _orderCreateAPI = [[CKRechargeOrderCreateAPI alloc] init];
        _orderCreateAPI.delegate = self;
    }
    return _orderCreateAPI;
}

- (void)paymentFinishCheck
{
//    if (!self.flow_id || !self.order_id) {
//        return;
//    }
//    
//    NSArray* arr = @[@{@"flow_id":self.flow_id}];
//    [CQNetsAPIListService userRelate_UserUpdateRechargeOrderAmount:self.total_amount order_id:self.order_id trading_infos:arr response:nil];
}

@end
