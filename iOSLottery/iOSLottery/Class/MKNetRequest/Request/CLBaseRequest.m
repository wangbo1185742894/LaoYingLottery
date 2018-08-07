//
//  CQBaseRequest.m
//  caiqr
//
//  Created by 彩球 on 16/9/5.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CLBaseRequest.h"
#import "CLNetworkAgent.h"
#import "CLNetworkReachabilityManager.h"


NSString * const kCLAPIBaseRequestDataTaskID = @"kCLAPIBaseRequestDataTaskID";

@interface CLBaseRequest ()

@property (nonatomic) BOOL isLoading;

@end


@implementation CLBaseRequest

- (instancetype) init
{
    self = [super init];
    if (self) {
        _delegate = nil;
        _paramSource = nil;
        
        if ([self conformsToProtocol:@protocol(CLBaseConfigRequest)]) {
            self.child = (id <CLBaseConfigRequest>)self;
        } else {
            NSException *exception = [[NSException alloc] init];
            @throw exception;
        }
    }
    return self;
}


//request start
- (void) start {
    
    if (self.isLoading) {
        return;
    }
    
    NSDictionary *apiParams = self.isRequestParams;
    
    if ([self shouldCallAPIWithParams:apiParams]) {
        
        //检测数据
        
        //检测缓存
        
        //检测网络
        self.isLoading = YES;
        
        __weak typeof(self) _weakSelf = self;
        [CLNetworkAgent launchRequest:self success:^(CLUrlResponse *response) {
            
            [_weakSelf requestSuccessCallbackWithUrlResponse:response];
            
        } fail:^(CLUrlResponse *response) {
            [_weakSelf requestFailCallbackWithUrlResponse:response withErrorType:CLRequestErrorTypeDefault];
        }];
        
        NSMutableDictionary *params = [apiParams mutableCopy];
        params[kCLAPIBaseRequestDataTaskID] = @(self.sessionDataTask.taskIdentifier);
        [self afterCallingAPIWithParams:params];
//
//        } else {
//            [self requestFailCallbackWithUrlResponse:nil withErrorType:CLRequestErrorTypeNotNetwork];//网络不可用
//        }
    } else {
        [self requestFailCallbackWithUrlResponse:nil withErrorType:CLRequestErrorTypeParamsError];//参数错误
    }
    
}

//request cancel
- (void) cancel
{
    if (!self.sessionDataTask) return;
    
    if (self.requestRunState == NSURLSessionTaskStateCanceling ||
        self.requestRunState == NSURLSessionTaskStateCompleted) {
        return;
    }
    
    [self.sessionDataTask cancel];
    if ([self.delegate respondsToSelector:@selector(cancelRequest:)]) {
        [self.delegate cancelRequest:self];
    }
}

#pragma mark - Setting Callback block

- (void)startWithCompletionBlockWithSuccess:(CLRequestCompletionBlock)success
                                    failure:(CLRequestCompletionBlock)failure {
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}

- (void)setCompletionBlockWithSuccess:(CLRequestCompletionBlock)success
                              failure:(CLRequestCompletionBlock)failure {
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

#pragma mark - CallBack

- (void) requestSuccessCallbackWithUrlResponse:(CLUrlResponse*)urlResponse {
    
    self.isLoading = NO;
    [self setValue:urlResponse forKey:@"urlResponse"];
    //校验是否本地化
    
    if ([self beforePerformSuccessWithResponse:urlResponse]) {
        if ([self.delegate respondsToSelector:@selector(requestFinished:)]) {
            [self.delegate requestFinished:self];
        }
    }
}

- (void) requestFailCallbackWithUrlResponse:(CLUrlResponse*)urlResponse withErrorType:(CLRequestErrorType)errorType {
    
    _errorType = errorType;
    self.isLoading = NO;
    [self setValue:urlResponse forKey:@"urlResponse"];
    
    if (errorType == CLRequestErrorTypeNotNetwork) {
        //无网络
        if ([self beforePerformFailWithResponse:urlResponse]) {
            if ([self.delegate respondsToSelector:@selector(requestFailed:)]) {
                [self.delegate requestFailed:self];
            }
        }
        [self afterPerformFailWithResponse:urlResponse];

        return;
    }
    if ((urlResponse.httpUrlResponse.statusCode >= 400) && (urlResponse.httpUrlResponse.statusCode < 500)) {
        //校验错误 - 请求是成功的 (此状态存在token无效 等信息)
        
        NSLog(@"%@",urlResponse.error);
        
        if ([self beforePerformSuccessWithResponse:urlResponse]) {
            if ([self.delegate respondsToSelector:@selector(requestFinished:)]) {
                [self.delegate requestFinished:self];
            }
            
        }
        /*
         if ([self beforePerformFailWithResponse:urlResponse]) {
            [self.delegate requestFailed:self];
        }*/
        
        //[self afterPerformFailWithResponse:urlResponse];
    } else {
        //其他错误
        if ([urlResponse.error code] == NSURLErrorTimedOut) {
            _errorType = CLRequestErrorTypeTimeout;
        }
        
        
        if ([self beforePerformFailWithResponse:urlResponse]) {
            if ([self.delegate respondsToSelector:@selector(requestFailed:)]) {
                [self.delegate requestFailed:self];
            }
        }
        [self afterPerformFailWithResponse:urlResponse];
    }
}


#pragma mark - interceptor

//只有返回YES才会继续调用API
- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(request:shouldCallAPIWithParams:)]) {
        return [self.interceptor request:self shouldCallAPIWithParams:params];
    } else {
        return YES;
    }
}

- (void)afterCallingAPIWithParams:(NSDictionary *)params
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(request:afterCallingAPIWithParams:)]) {
        [self.interceptor request:self afterCallingAPIWithParams:params];
    }
}

- (BOOL)beforePerformSuccessWithResponse:(CLUrlResponse *)response
{
    BOOL result = YES;
    
    _errorType = CLRequestErrorTypeSuccess;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(request:beforePerformSuccessWithResponse:)]) {
        result = [self.interceptor request:self beforePerformSuccessWithResponse:response];
    }
    return result;
}

- (BOOL)beforePerformFailWithResponse:(CLUrlResponse *)response
{
    BOOL result = YES;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(request:beforePerformFailWithResponse:)]) {
        result = [self.interceptor request:self beforePerformFailWithResponse:response];
    }
    return result;
}


- (void)afterPerformFailWithResponse:(CLUrlResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(request:afterPerformFailWithResponse:)]) {
        [self.interceptor request:self afterPerformFailWithResponse:response];
    }
}


#pragma mark - Network reachable

- (BOOL)isReachable
{
    
    BOOL isReachability = ([CLNetworkReachabilityManager currentNetworkState] != CLNetworkReachabilityStatusNotReachable);
    if (!isReachability) {
        _errorType = CLRequestErrorTypeNotNetwork;
    }
    return isReachability;
}


#pragma mark - getter method

- (NSDictionary*)isRequestParams{
    
    NSMutableDictionary *apiParams = [NSMutableDictionary dictionaryWithCapacity:0];
    if (self.child && [self.child respondsToSelector:@selector(requestBaseParams)]) {
        [apiParams addEntriesFromDictionary:[self.child requestBaseParams]];
    }
    
    if (self.paramSource && [self.paramSource respondsToSelector:@selector(paramsForPostApi:)]) {
        [apiParams addEntriesFromDictionary:[self.paramSource paramsForPostApi:self]];
    }
    
    return apiParams;
}

- (NSURLSessionTaskState)requestRunState{
    
    return self.sessionDataTask.state;
}

- (NSInteger)responseStatusCode{
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)self.sessionDataTask.response;
    return httpResponse.statusCode;
}

- (NSDictionary *)responseHeaders{
    
    return [(NSHTTPURLResponse*)self.sessionDataTask.response allHeaderFields];
}


//- (CQRequestHttpCodeType)responseHttpCodeType
//{
//    CQRequestHttpCodeType type = CQRequestHttpCodeNone;

//    if (self.responseStatusCode < 400){
//        type = CQRequestHttpCodeSuccess;
//    } else if ((self.responseStatusCode >= 400) && (self.responseStatusCode < 500)) {
//        type = CQRequestHttpCodeFailureHttp;
//    } else if (self.responseStatusCode >= 500) {
//        type = CQRequestHttpCodeFailureService;
//    }
//    return type;
//}


@end







