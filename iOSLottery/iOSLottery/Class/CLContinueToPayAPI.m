//
//  CLContinueToPayAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/26.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLContinueToPayAPI.h"
#import "CLAppContext.h"

@interface CLContinueToPayAPI () <CLBaseConfigRequest>

@property (nonatomic) NSInteger orderType;

@end

@implementation CLContinueToPayAPI

- (NSString *)methodName {
    
    return @"continueToPay";
}

- (NSString *)requestBaseUrlSuffix {
    
    return @"/continueToPay";
}

- (NSDictionary *)requestBaseParams {
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:0];
    [param setObject:[[CLAppContext context] token] forKey:@"token"];
    [param setObject:@"1" forKey:@"client"];
    if (_orderId) [param setObject:_orderId forKey:@"orderId"];
    if (_followId) [param setObject:_followId forKey:@"orderId"];
    [param setObject:[NSString stringWithFormat:@"%zi",self.orderType] forKey:@"orderType"];
    return param;
}

- (void)setFollowId:(NSString *)followId {
    
    _followId = followId;
    self.orderType = 2;
}

- (void)setOrderId:(NSString *)orderId {
    
    _orderId = orderId;
    self.orderType = 1;
}

@end
