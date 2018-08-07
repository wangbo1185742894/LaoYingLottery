//
//  CQBaseRequest.h
//  caiqr
//
//  Created by 彩球 on 16/9/5.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLUrlResponse.h"


typedef NS_ENUM(NSInteger, CLRequestType){
    CLRequestTypePOST = 0 ,
    CLRequestTypeGET,
};


typedef NS_ENUM(NSInteger , CLRequestPriority) {
    CQRequestPriorityLow = -4L,
    CQRequestPriorityDefault = 0,
    CQRequestPriorityHigh = 4,
};

typedef NS_ENUM(NSInteger, CLRequestErrorType)
{
    CLRequestErrorTypeDefault,
    CLRequestErrorTypeSuccess,
    CLRequestErrorTypeNoContent,
    CLRequestErrorTypeParamsError,
    CLRequestErrorTypeTimeout,
    CLRequestErrorTypeNotNetwork,
    
};

typedef NS_ENUM(NSInteger, CQRequestError)
{
    CLRequestErrorValidBody = -10000,
};

@class CLBaseRequest;
//由于添加了 nullable 会报警告 所以需要 添加 NS_ASSUME_NONNULL_BEGIN  NS_ASSUME_NONNULL_END
NS_ASSUME_NONNULL_BEGIN
typedef void(^CLRequestCompletionBlock)(CLBaseRequest * request);

// 在调用成功之后的params字典里面，用这个key可以取出requestID
extern NSString * const kCLAPIBaseRequestDataTaskID;



/*************************************************************************************************/
/*                                          CQBaseRequest                                        */
/*************************************************************************************************/


@protocol CLBaseConfigRequest <NSObject>

@optional

/** 请求名称 */
- (NSString*)methodName;

/** 请求类型 POST GET PUT DELETE */
- (CLRequestType)requestType;

/** 请求的连接超时时间，默认为10秒 */
- (NSTimeInterval)requestTimeoutInterval;

/** 请求Url附加部分 
 *  使用时与 <CQRequestParamSource> urlSiffixForApi:request 互斥
 */
- (NSString *)requestBaseUrlSuffix;

/** 固定Post请求体 
 *  使用时在 <CQRequestParamSource> paramsForPostApi:request 之前调用
 */
- (NSDictionary *)requestBaseParams;

@end

/*************************************************************************************************/
/*                                       CLBaseCallBackConfig                                    */
/*************************************************************************************************/

@protocol CLBaseCallBackConfig <NSObject>

@optional

- (void) requestSuccessCallbackWithUrlResponse:(CLUrlResponse*)urlResponse;

- (void) requestFailCallbackWithUrlResponse:(CLUrlResponse*)urlResponse withErrorType:(CLRequestErrorType)errorType;

@end



/*************************************************************************************************/
/*                                       CLRequestParamSource                                    */
/*************************************************************************************************/

/** 请求Body参数拼接代理 */
@protocol CLRequestParamSource <NSObject>

@optional
//请求url后缀
- (NSString *)urlSuffixForApi:(CLBaseRequest *)request;

//请求体Post
- (NSDictionary *)paramsForPostApi:(CLBaseRequest *)request;

@end

/*************************************************************************************************/
/*                                       CLRequestBasicConfig                                    */
/*************************************************************************************************/

@class CLAppNetAPIClient;

/** 请求基础信息 */
@protocol CLRequestBasicConfig <NSObject>

@optional

//请求Basic Url
- (NSString *)apiBaseUrl;

//请求体Body签名私钥
- (NSString *)apiSignPrivateKey;

//附加Body
- (NSDictionary *) paramsAdditional:(CLBaseRequest *)request;

//自建请求头
- (void) signRequestapiClient:(CLAppNetAPIClient*)apiClient requestType:(CLRequestType)requestType Params:(NSDictionary*)apiParams;

@end

/*************************************************************************************************/
/*                                  CLRequestCallBackDelegate                                    */
/*************************************************************************************************/
/** 请求统一回调代理 */

@protocol CLRequestCallBackDelegate <NSObject>

@optional
/** 请求成功 */
- (void)requestFinished:(CLBaseRequest *)request;

/** 请求失败 */
- (void)requestFailed:(CLBaseRequest *)request;

/** 请求取消 */
- (void)cancelRequest:(CLBaseRequest *)request;

@end


/*************************************************************************************************/
/*                                       CLRequestInterceptor                                    */
/*************************************************************************************************/
/** 请求拦截器 */

@protocol CLRequestInterceptor <NSObject>

@optional

- (BOOL)request:(CLBaseRequest *)request beforePerformSuccessWithResponse:(CLUrlResponse *)response;
- (void)request:(CLBaseRequest *)request afterPerformSuccessWithResponse:(CLUrlResponse *)response;

- (BOOL)request:(CLBaseRequest *)request beforePerformFailWithResponse:(CLUrlResponse *)response;
- (void)request:(CLBaseRequest *)request afterPerformFailWithResponse:(CLUrlResponse *)response;

/** 请求参数拦截
 *
 *  shouldCallAPI       参数是否支持API调用回调
 *  afterCallingAPI     API调用之后回调
 */
- (BOOL)request:(CLBaseRequest *)request shouldCallAPIWithParams:(NSDictionary *)params;
- (void)request:(CLBaseRequest *)request afterCallingAPIWithParams:(NSDictionary *)params;

@end


/*************************************************************************************************/
/*                                        CQBaseRequest                                          */
/*************************************************************************************************/

@interface CLBaseRequest : NSObject <CLBaseCallBackConfig>

/** 请求代理 */
@property (nonatomic, weak) id<CLRequestCallBackDelegate> delegate;

@property (nonatomic, weak) id<CLRequestParamSource> paramSource;

@property (nonatomic, weak) id<CLRequestInterceptor> interceptor;

@property (nonatomic, weak) id<CLRequestBasicConfig> baseUrlConfig;

@property (nonatomic, weak) id<CLBaseConfigRequest> child;


/** 请求urlResponse */
@property (nonatomic, readonly, strong) CLUrlResponse* urlResponse;

/** 请求dataTask */
@property (nonatomic, readonly, strong) NSURLSessionDataTask* sessionDataTask;

/** all request headers */
@property (nonatomic, readonly, strong) NSDictionary *responseHeaders;

/** http response state code */
@property (nonatomic, readonly) NSInteger responseStatesCode;

/** sessionTask State */
@property (nonatomic, readonly) NSURLSessionTaskState requestRunState;

/** post body params (NSDictionary) */
@property (nonatomic, readonly, getter=isRequestParams) NSDictionary *requestParams;

/** 请求成功回调block */
@property (nonatomic, copy) CLRequestCompletionBlock successCompletionBlock;

/** 请求失败回调block */
@property (nonatomic, copy) CLRequestCompletionBlock failureCompletionBlock;

/** 请求优先级 */
@property (nonatomic) CLRequestPriority requestPriority;

@property (nonatomic, readonly) CLRequestErrorType errorType;


NS_ASSUME_NONNULL_END
/** 发起请求 */
- (void)start;

/** 取消请求 */
- (void)cancel;


/// block回调
- (void)startWithCompletionBlockWithSuccess:(nullable CLRequestCompletionBlock)success
                                    failure:(nullable CLRequestCompletionBlock)failure;

- (void)setCompletionBlockWithSuccess:(nullable CLRequestCompletionBlock)success
                              failure:(nullable CLRequestCompletionBlock)failure;


@end











