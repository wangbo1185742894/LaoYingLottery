//
//  CQNetworkAgent.h
//  caiqr
//
//  Created by 彩球 on 16/9/5.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLBaseRequest;
@class CLUrlResponse;

typedef void(^CLCallback)(CLUrlResponse *response);

@interface CLNetworkAgent : NSObject

+ (void)launchRequest:(CLBaseRequest*)request success:(CLCallback)success fail:(CLCallback)fail;

+ (void)launchRequest:(CLBaseRequest*)request params:(NSDictionary*)apiParams apiUrl:(NSString*)url success:(CLCallback)success fail:(CLCallback)fail;

@end

