//
//  CLCaiqrBusinessRequest.m
//  iOSLottery
//
//  Created by 彩球 on 17/2/25.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLCaiqrBusinessRequest.h"
#import "CLCaiqrBalancing.h"
#import "CLAppContext.h"
#import "DataSigner.h"
#import "CLQueryStringPairs.h"
#import "CLAppNetAPIClient.h"


@interface CLCaiqrBusinessRequest () <CLRequestBasicConfig,CLBaseConfigRequest>

@property (nonatomic, strong) CLCaiqrBalancing* balancing;

@end

@implementation CLCaiqrBusinessRequest

- (instancetype) init {
    
    self = [super init];
    if (self) {
        
        self.baseUrlConfig = self;
    }
    return self;
    
}

- (NSString *)requestBaseUrlSuffix {
    
    //彩球业务请求 api/后追加cmd业务
    id cmd = self.requestParams[@"cmd"];
    if ([cmd isKindOfClass:NSString.class] && [(NSString*)cmd length] > 0 ) {
        return [NSString stringWithFormat:@"/api/%@",cmd];
    }
    return @"/api";
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
        return @{@"token":token,@"ticket_type":@"001"};
    }
    return @{@"ticket_type":@"001"};
}

- (void)signRequestapiClient:(CLAppNetAPIClient *)apiClient requestType:(CLRequestType)requestType Params:(NSDictionary *)apiParams {
    
    NSString* private_key = [self apiSignPrivateKey];
    id<DataSigner> signer = CreateRSADataSigner(private_key);
    NSString *signedString = [signer signString:CLQueryStringFromParameters(apiParams,YES)];
    signedString = [signedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [apiClient.requestSerializer setValue:signedString forHTTPHeaderField:@"Caiqr-Signature"];
    
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

- (CLCaiqrBalancing *)balancing {
    
    if (!_balancing) {
        _balancing = [CLCaiqrBalancing sharedBalancing];
    }
    return _balancing;
}

@end
