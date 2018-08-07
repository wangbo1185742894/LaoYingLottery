//
//  PZAppNetAPIClient.h
//  caiqr
//
//  Created by Apple on 14/12/20.
//  Copyright (c) 2014年 Paul. All rights reserved.
//

#import <AFHTTPSessionManager.h>
#import <AFURLRequestSerialization.h>


@protocol PZAPPNetApiClientConfig <NSObject>

- (void) configApiClient;

@end

@interface CLAppNetAPIClient : AFHTTPSessionManager <PZAPPNetApiClientConfig>

+ (instancetype)sharedClient;

/** 启用https */
- (void) launchHttpsService;

@end
