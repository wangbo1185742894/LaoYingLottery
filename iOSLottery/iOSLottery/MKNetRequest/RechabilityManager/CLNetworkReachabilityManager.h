//
//  CLNetworkReachabilityManager.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/4.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>

/** NSNotification Name
 *
 *  NetworkReachabilityDidChangeNotificationName  -- networkStatus DidChange
 *  NetworkReachabilityInvalidToValidNotificationName -- networkStatus Unknown/NotReachable Change ReachableViaWWAN/ReachableViaWiFi
 */
extern NSString* const NetworkReachabilityDidChangeNotificationName;
extern NSString* const NetworkReachabilityInvalidToValidNotificationName;

/** Enum 
 *
 *  NetworkReachabilityStatus
 */

typedef NS_ENUM(NSInteger, CLNetworkReachabilityStatus) {
    CLNetworkReachabilityStatusUnknown          = -1,
    CLNetworkReachabilityStatusNotReachable     = 0,
    CLNetworkReachabilityStatusReachableViaWWAN = 1,
    CLNetworkReachabilityStatusReachableViaWiFi = 2,
};

/** Struct
 *
 *  container about change before and after networkstatus
 */

typedef struct CLNetworkStatus {
    NSInteger new_status;
    NSInteger old_status;
}CLNetworkStatus;


/** 返回网络状态结构体 */
CLNetworkStatus networkStatus(NSValue *networkStatus);

@interface CLNetworkReachabilityManager : NSObject

+ (void) startMonitoring;

+ (CLNetworkReachabilityStatus)currentNetworkState;

@end
