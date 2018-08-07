//
//  PZAppNetAPIClient.h
//  caiqr
//
//  Created by Apple on 14/12/20.
//  Copyright (c) 2014年 Paul. All rights reserved.
//

#import <AFHTTPSessionManager.h>
#import <AFURLRequestSerialization.h>

typedef NS_ENUM(NSUInteger, MKSSLPinningMode) {
    MKSSLPinningModeNone,
    MKSSLPinningModePublicKey,
    MKSSLPinningModeCertificate,
};


@protocol PZAPPNetApiClientConfig <NSObject>

- (void) configApiClient;

@end

@interface CLAppNetAPIClient : AFHTTPSessionManager <PZAPPNetApiClientConfig>

+ (instancetype)sharedClient;


//设置启用https ssl认证模式
@property (nonatomic) MKSSLPinningMode securityPolicyPinningMode;


@end
