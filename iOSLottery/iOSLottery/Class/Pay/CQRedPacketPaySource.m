//
//  CQRedPacketPaySource.m
//  caiqr
//
//  Created by 彩球 on 16/7/4.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CQRedPacketPaySource.h"
//#import "CQNetsAPIList.h"
#import "CQPayOrderInfo.h"
#import "CQDefinition.h"
#import "CLRedEnveOrderCreateAPI.h"
#import "CLLoadingAnimationView.h"
@interface CQRedPacketPaySource ()<CLRequestCallBackDelegate>

@property (nonatomic, strong) CLRedEnveOrderCreateAPI* orderCreateAPI;

@end

@implementation CQRedPacketPaySource


/** override */

- (void)runPayment
{
    self.orderCreateAPI.amount = self.total_amount;
    self.orderCreateAPI.need_channels = [NSString stringWithFormat:@"%zi",self.channel_type];
    self.orderCreateAPI.trading_infos = [self.redPaTradingInfo mj_JSONString];
    self.orderCreateAPI.red_program_id = self.redPaProgramId;
    self.orderCreateAPI.card_no = self.card_no;
    [[CLLoadingAnimationView shareLoadingAnimationView] showLoadingAnimationInCurrentViewControllerWithType:CLLoadingAnimationTypeNormal];
    [self.orderCreateAPI start];
    
}

#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    
    if (request.urlResponse.success) {
        [self createRedPacketCallBack:[request.urlResponse.resp firstObject]];
    } else {
        (!self.createPayForToken)?nil:self.createPayForToken(NO,request.urlResponse.errorMessage);
    }
    [[CLLoadingAnimationView shareLoadingAnimationView] stop];
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    [[CLLoadingAnimationView shareLoadingAnimationView] stop];
    (!self.createPayForToken)?nil:self.createPayForToken(NO,request.urlResponse.error);
    [self createRedPacketCallBack:nil];
}

- (void)createRedPacketCallBack:(id)info
{
//    NSLog(@"--%@",info);
    CQRechagreInfo* obj = [CQRechagreInfo mj_objectWithKeyValues:info];
    if (!obj) {
        if (self.createPayForToken)
            self.createPayForToken(NO,@"支付异常");
        
        return;
    }
    
    if (self.createPayForToken) {
        self.createPayForToken(YES,obj);
    }
    CQPayToken *token = [obj.pay_for_tokens firstObject];
    
    self.flow_id = token.flow_id;
    self.orderId = obj.order_info.order_id;
    
    NSDictionary* parameter = [CQSportsBetPaymentHandler parameterTotalAccount:self.total_amount payAccount:self.total_amount redAccount:nil hasRedPacket:NO redProgramsId:self.redPaProgramId flowId:token.flow_id payForToken:token.pay_for_token redOrderId:obj.order_info.order_id];
    
    if (self.willOpenSafari) {
        self.willOpenSafari();
    }
    
    if (self.channel_type == paymentChannelTypeAliPay && token.pay_for_token.length > 0) {
        NSDictionary* dict = [token.pay_for_token mj_JSONObject];
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
                                                          transitionType:self.transitionType
                                                      paymentChannelType:self.channel_type
                                            paymentChannelConfigH5String:self.url_prefix
                                                          viewController:self.launch_class];
    
    if (self.didOpenSafari) {
        self.didOpenSafari();
    }
    
}


- (void)paymentFinishCheck
{
    if (!self.flow_id || !self.orderId) return;
}

- (CLRedEnveOrderCreateAPI *)orderCreateAPI {
    
    if (!_orderCreateAPI) {
        _orderCreateAPI = [[CLRedEnveOrderCreateAPI alloc] init];
        _orderCreateAPI.delegate = self;
    }
    return _orderCreateAPI;
}

@end
