//
//  SLOrderContinuePayRequest.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/6/19.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLOrderContinuePayRequest.h"

#import "SLExternalService.h"


@implementation SLOrderContinuePayRequest


- (NSString *)requestBaseUrlSuffix {
    
    return @"/continueToPay";
}

- (NSDictionary *)requestBaseParams {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [param setObject:[SLExternalService getToken] forKey:@"token"];
    [param setObject:@"1" forKey:@"client"];
    
    if (_orderId) [param setObject:_orderId forKey:@"orderId"];
    [param setObject:@"1" forKey:@"orderType"];
    return param;
}


@end
