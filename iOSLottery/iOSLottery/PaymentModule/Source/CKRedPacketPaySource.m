//
//  CQRedPacketPaySource.m
//  caiqr
//
//  Created by 彩球 on 16/7/4.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CKRedPacketPaySource.h"
#import "CKReachargeCashModel.h"
#import "CKRedEnveOrderCreateAPI.h"
#import "CKPayClient.h"
@interface CKRedPacketPaySource ()<CLRequestCallBackDelegate>

@property (nonatomic, strong) CKRedEnveOrderCreateAPI* orderCreateAPI;

@end

@implementation CKRedPacketPaySource


/** override */

- (void)runPayment
{
    
    if (self.channel_type == CKPaymentChannelTypeAccountBalance)
    {
        NSMutableDictionary* parameter = [NSMutableDictionary new];
        [parameter addEntriesFromDictionary:[CKSportsBetPaymentHandler parameterTotalAccount:self.total_amount payAccount:self.total_amount redAccount:nil hasRedPacket:NO redProgramsId:nil flowId:self.flow_id payForToken:nil redOrderId:nil]];
        [parameter setObject:[NSString stringWithFormat:@"%zi",self.channel_type] forKey:@"typeId"];
        
        (!self.callBackH5Pay)?:self.callBackH5Pay(parameter);
        
    } else {
        
        
        
        (!self.startNativeRequest)?:self.startNativeRequest();
        
        self.orderCreateAPI.amount = self.total_amount;
        self.orderCreateAPI.need_channels_id = [NSString stringWithFormat:@"%zi",self.channel_type];
        self.orderCreateAPI.pre_handle_token = self.flow_id;
        self.orderCreateAPI.card_no = self.card_no;
        [[CKPayClient sharedManager].intermediary startLoading];
        [self.orderCreateAPI start];
        
    }
}


#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    [[CKPayClient sharedManager].intermediary stopLoading];
    if (request.urlResponse.success) {
        [self createRedPacketCallBack:[request.urlResponse.resp firstObject]];
    } else {
        (!self.endNativeRequest)?:self.endNativeRequest(NO,request.urlResponse.errorMessage);
    }
}

- (void)requestFailed:(CLBaseRequest *)request {
    [[CKPayClient sharedManager].intermediary stopLoading];
    (!self.endNativeRequest)?:self.endNativeRequest(NO,request.urlResponse.error);
//    [self createRedPacketCallBack:nil];
}

- (void)createRedPacketCallBack:(id)info
{
    NSLog(@"--%@",info);
    CKReachargeCashModel* obj = [CKReachargeCashModel objectWithKeyValues:info];
    if (!obj) {
         (!self.endNativeRequest)?:self.endNativeRequest(NO,@"支付异常");
        return;
    } else {
        (!self.endNativeRequest)?:self.endNativeRequest(YES,@"");
    }
    
    self.flow_id = obj.flow_id;
    self.orderId = obj.handle_id;
    
    NSDictionary* parameter = [CKSportsBetPaymentHandler parameterTotalAccount:self.total_amount payAccount:self.total_amount redAccount:nil hasRedPacket:NO redProgramsId:self.redPaProgramId flowId:obj.flow_id payForToken:obj.pay_for_token redOrderId:obj.handle_id];
    (!self.callBackSDKPay)?:self.callBackSDKPay(obj.pay_channel_key,obj.pay_for_token,parameter);
}

- (CKRedEnveOrderCreateAPI *)orderCreateAPI {
    
    if (!_orderCreateAPI) {
        _orderCreateAPI = [[CKRedEnveOrderCreateAPI alloc] init];
        _orderCreateAPI.delegate = self;
    }
    return _orderCreateAPI;
}

- (void)paymentFinishCheck
{
//    if (!self.flow_id || !self.orderId) return;
//    
//    NSArray* arr = @[@{@"flow_id":self.flow_id}];
//    [CQNetsAPIListService userRelate_UserRedPacketsMakeSureAmount:self.total_amount orderId:self.orderId trading_info:arr response:nil];
}
    
@end
