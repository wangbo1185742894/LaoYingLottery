//
//  CLNetworkReachabilityManager.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/4.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLNetworkReachabilityManager.h"
#import <AFNetworkReachabilityManager.h>

@implementation CLNetworkReachabilityManager

NSString* const NetworkReachabilityDidChangeNotificationName = @"CLNetworkReachabilityDidChangeNotificationName";
NSString* const NetworkReachabilityInvalidToValidNotificationName = @"CLNetworkReachabilityInvalidToValidNotificationName";

/** 返回网络状态结构体 */
CLNetworkStatus networkStatus(NSValue *networkStatusValue)
{
    CLNetworkStatus networkStatus;
    [networkStatusValue getValue:&networkStatus];
    return networkStatus;
}

+ (void) startMonitoring {
    /*-----------开启网络状态监听----------*/
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [CLNetworkReachabilityManager reachabilityNetworkStateDidChangeState:status];
    }];
//    开启网络监听
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (CLNetworkReachabilityStatus)currentNetworkState
{
    return (CLNetworkReachabilityStatus)[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
}


+ (void)reachabilityNetworkStateDidChangeState:(AFNetworkReachabilityStatus)state {
    
    /** 每次状态改变 发送通知 */
    if (state == AFNetworkReachabilityStatusUnknown ||
        state == AFNetworkReachabilityStatusNotReachable) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NetworkReachabilityDidChangeNotificationName object:nil userInfo:@{@"has_Net" : @(0)}];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:NetworkReachabilityDidChangeNotificationName object:nil userInfo:@{@"has_Net" : @(1)}];
    }
}




@end
