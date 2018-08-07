//
//  CLLotteryBusinessRequest.m
//  iOSLottery
//
//  Created by 彩球 on 17/2/25.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLLotteryBusinessRequest.h"
#import "CLLotteryBalancing.h"
#import "CLAppContext.h"
#import "DataSigner.h"
#import "CLQueryStringPairs.h"
#import "CLAppNetAPIClient.h"

@interface CLLotteryBusinessRequest () <CLRequestBasicConfig>

@property (nonatomic, strong) CLLotteryBalancing* balancing;

@end

@implementation CLLotteryBusinessRequest

- (instancetype) init {
    
    self = [super init];
    if (self) {
        
        self.baseUrlConfig = self;
    }
    return self;
    
}

#pragma mark - CLRequestBasicConfig

- (NSString *)apiBaseUrl {
    
    return self.balancing.apiUrl;
}

- (NSString *)apiSignPrivateKey {
    
    return self.balancing.privateKey;
}

- (NSDictionary *)paramsAdditional:(CLBaseRequest *)request {

    NSString *token = [[CLAppContext context] token];
    if (token && token.length > 0) {
        return @{@"token":token};
    }
    return @{};
    
}

- (void)signRequestapiClient:(CLAppNetAPIClient *)apiClient requestType:(CLRequestType)requestType Params:(NSDictionary *)apiParams {
    
    NSString* private_key = [self apiSignPrivateKey];
    id<DataSigner> signer = CreateRSADataSigner(private_key);
    NSString *signedString = [signer signString:CLQueryStringFromParameters(apiParams,YES)];
    signedString = [signedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [apiClient.requestSerializer setValue:signedString forHTTPHeaderField:@"Caiqr-Signature"];
    
    
    NSString *eaglesignedString = [signer signString:CLQueryStringFromParameters(apiParams,NO)];
    [apiClient.requestSerializer setValue:eaglesignedString forHTTPHeaderField:@"Eagle-Signature"];
}


#pragma mark - override request response

//请求成功回调
//- (void)requestSuccessCallbackWithUrlResponse:(CLUrlResponse *)urlResponse {
//
//    [super requestSuccessCallbackWithUrlResponse:urlResponse];
//}

//请求失败
- (void)requestFailCallbackWithUrlResponse:(CLUrlResponse *)urlResponse withErrorType:(CLRequestErrorType)errorType {
    if (urlResponse.networkSwitchUrl) [self.balancing switchKeyUrl];
    [super requestFailCallbackWithUrlResponse:urlResponse withErrorType:errorType];
}

#pragma mark - getter

- (CLLotteryBalancing *)balancing {
    
    if (!_balancing) {
        _balancing = [CLLotteryBalancing sharedBalancing];
    }
    return _balancing;
}

@end
