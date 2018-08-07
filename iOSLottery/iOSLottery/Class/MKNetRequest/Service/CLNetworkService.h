//
//  CLNetworkService.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//


/*
    配置urlPrefix 与 params
 */
#import <Foundation/Foundation.h>

@class CLBaseRequest;

@interface CLNetworkService : NSObject

+ (NSString*) requestUrlAssisgnmentWith:(CLBaseRequest*)request;

+ (NSDictionary*) requestParamsAssignmentWith:(CLBaseRequest*)request;

@end
