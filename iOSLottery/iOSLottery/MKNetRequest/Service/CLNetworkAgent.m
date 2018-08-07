//
//  CLNetworkAgent.m
//  caiqr
//
//  Created by 彩球 on 16/9/5.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CLNetworkAgent.h"
#import "CLAppNetAPIClient.h"
#import "NSError+CQError.h"
#import "CLBaseRequest.h"
#import "CLUrlResponse.h"
#import "CLNetworkService.h"
#import "DataSigner.h"

#define APP_API_VERSION @"1.2"
#define REQUEST_TIMEOUT_INTERVAL 10.f


NSTimeInterval requestTimeoutIntervalAvailbaleCheck(NSTimeInterval timeInterval) {
    timeInterval = timeInterval < 1? REQUEST_TIMEOUT_INTERVAL : timeInterval;
    timeInterval = timeInterval > 120? REQUEST_TIMEOUT_INTERVAL : timeInterval;
    return timeInterval;
}

@implementation CLNetworkAgent


+ (void)launchRequest:(CLBaseRequest*)request success:(CLCallback)success fail:(CLCallback)fail{
    
    //拼接baseUrl + cdnUrl
    NSString* apiUrl = [CLNetworkService requestUrlAssisgnmentWith:request];
    
    //创建apiParams
    NSDictionary* params = [CLNetworkService requestParamsAssignmentWith:request];
        
    [CLNetworkAgent launchRequest:request params:params apiUrl:apiUrl success:success fail:fail];

//    [CLNetworkAgent launchDeBugRequest:request params:params success:success fail:fail];
    
}

/** 支持更换请求第三方 */
+ (void)launchRequest:(CLBaseRequest*)request params:(NSDictionary*)apiParams apiUrl:(NSString*)url success:(CLCallback)success fail:(CLCallback)fail {
    
    CLAppNetAPIClient* apiClient = [CLAppNetAPIClient sharedClient];
    // set request timeout
    NSInteger timeoutInterval = ([request.child respondsToSelector:@selector(requestTimeoutInterval)])?[request.child requestTimeoutInterval]:REQUEST_TIMEOUT_INTERVAL;
    [apiClient.requestSerializer setTimeoutInterval:requestTimeoutIntervalAvailbaleCheck(timeoutInterval)];
    
    //获取请求模式
    CLRequestType requestType = CLRequestTypePOST;
    if (request.child && [request.child respondsToSelector:@selector(requestType)]) {
        requestType = [request.child requestType];
    }
    
    //对参数进行加密 追加到请求头中 <POST请求需要增加签名>
    if (requestType == CLRequestTypePOST) {
        if (request.baseUrlConfig && [request.baseUrlConfig respondsToSelector:@selector(apiSignPrivateKey)]) {
            NSString* private_key = [request.baseUrlConfig apiSignPrivateKey];
            id<DataSigner> signer = CreateRSADataSigner(private_key);
            NSString *signedString = [signer signString:AFQueryStringFromParameters(apiParams)];
            signedString = [signedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [apiClient.requestSerializer setValue:signedString forHTTPHeaderField:@"caiqr-signature"];
        }
    }
    
    //配置请求BaseUrl
    NSString* baseUrl = @"";
    if (request.baseUrlConfig && [request.baseUrlConfig respondsToSelector:@selector(apiBaseUrl)]) {
        baseUrl = [request.baseUrlConfig apiBaseUrl];
    }
    [apiClient setValue:[NSURL URLWithString:baseUrl] forKey:@"baseURL"];

    NSURLSessionDataTask* dataTask = nil;
    
    if (requestType == CLRequestTypePOST) { //POST
        dataTask = [apiClient POST:url parameters:apiParams progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            CLUrlResponse* response = [[CLUrlResponse alloc] initWithResponseDataTask:task object:responseObject status:1];
            success?success(response):nil;
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            CLUrlResponse* response = [[CLUrlResponse alloc] initWithResponseDataTask:task errpr:error];
            fail?fail(response):nil;
        }];
    }
    else if (requestType == CLRequestTypeGET) //GET
    {
        dataTask = [apiClient GET:url parameters:apiParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            CLUrlResponse* response = [[CLUrlResponse alloc] initWithResponseDataTask:task object:responseObject status:1];
            success?success(response):nil;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            CLUrlResponse* response = [[CLUrlResponse alloc] initWithResponseDataTask:task errpr:error];
            fail?fail(response):nil;
        }];
    }
    
    if (dataTask) [request setValue:dataTask forKey:@"sessionDataTask"];
    
}


/** 模拟网络请求回调方法 */
//+ (void)launchDeBugRequest:(CLBaseRequest *)request params:(NSDictionary *)apiParams success:(CLCallback)success fail:(CLCallback)fail {
//    
//    NSString* urlSuffix = nil;
//    if (request.paramSource && [request.paramSource respondsToSelector:@selector(urlSuffixForApi:)]) {
//        urlSuffix = [request.paramSource urlSuffixForApi:request];
//    } else {
//        if ([request.child respondsToSelector:@selector(requestBaseUrlSuffix)]) {
//            urlSuffix = [request.child requestBaseUrlSuffix];
//        }
//    }
//    
//    if (!urlSuffix) {
//        [CQNetworkAgent launchRequest:request params:apiParams apiUrl:nil success:success fail:fail];
//        return;
//    }
//    
//    //模拟成功回调
//    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        sleep(.5f);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            id objc = [CLNetworkTestDataManager testDataForApiUrl:urlSuffix params:apiParams];
//            CLUrlResponse* response = [[CLUrlResponse alloc] initWithResponseDataTask:nil object:objc status:1];
//            success?success(response):nil;
//        });
//    });
//}




@end



