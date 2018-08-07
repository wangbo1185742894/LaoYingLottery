//
//  CLUrlResponse.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/8.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLUrlResponse.h"
#import "NSError+CQError.h"

static NSString* CQNSURLErrorCancelled = @"请求取消";
static NSString* CQNSURLErrorTimedOut = @"请求超时";
static NSString* CQNSURLErrorCannotFindHost = @"不能找到主机";
static NSString* CQNSURLErrorCannotConnectToHost = @"不能连接到主机";
static NSString* CQNSURLErrorBadServerResponse = @"服务器异常";
static NSString* CQNSURLErrorNotConnectedToInternet = @"无法连接到网络";
static NSString* CQNSURLErrorURLErrorUnsupportedURL = @"未知url";
static NSString* CQNSURLErrorNetError = @"网络异常";

static NSString* CQNSURLErrorOtherError = @"测试-未记录的错误类型";

@implementation CLUrlResponse

- (instancetype) initWithResponseDataTask:(NSURLSessionTask*)dataTask object:(id)responseObject status:(NSInteger)status {
    
    self = [super init];
    if (self) {
        (responseObject)?[self setValue:responseObject forKey:@"responseObject"]:nil;
        (dataTask)?[self setValue:((NSHTTPURLResponse*)dataTask.response) forKey:@"httpUrlResponse"]:nil;
        
    }
    return self;
}

- (instancetype) initWithResponseDataTask:(NSURLSessionTask*)dataTask errpr:(NSError*)error {
    
    self = [super init];
    if (self) {
        (error.responseData)?[self setValue:error.responseData forKey:@"responseObject"]:nil;
        (dataTask)?[self setValue:((NSHTTPURLResponse*)dataTask.response) forKey:@"httpUrlResponse"]:nil;
        (error)?[self setValue:error forKey:@"error"]:nil;
    }
    return self;
}

- (NSInteger)dataCode {
    
    if (self.responseObject &&
        [self.responseObject isKindOfClass:[NSDictionary class]]) {
        
        NSInteger code = -1;
        id objc = [self.responseObject objectForKey:@"code"];
        if (objc) {
            code = [objc integerValue];
        }
        return code;
    } else {
        
        return -1;
    }
}

- (id)resp {
    
    if (self.success) {
        if ([self.responseObject objectForKey:@"resp"] && ![[self.responseObject objectForKey:@"resp"] isKindOfClass:[NSString class]]) {
            
            return [self.responseObject objectForKey:@"resp"];
        }
    }
    return nil;
}

- (BOOL) success {
    return (self.dataCode == 0);
}

- (NSString*) errorMessage {
    if (!self.responseObject) return nil;
    if (self.success) return nil;
    id msg = self.responseObject[@"msg"];
    
    if (msg && [msg isKindOfClass:[NSString class]]) {
        return msg;
    } else {
        if (self.error) {
         return [self errorMessage:self.error];
        }
    }
    return nil;
}

- (NSString*)errorMessage:(id)err
{
    if ([err isKindOfClass:[NSString class]])
    {
        return (NSString*)err;
    }
    else if ([err isKindOfClass:[NSError class]])
    {
        if ((YES))
        {
            //测试
            switch ([(NSError*)err code])
            {
                case NSURLErrorCancelled:return [NSString stringWithFormat:@"%@ errorCode:%zi",CQNSURLErrorCancelled,[(NSError*)err code]];break;
                case NSURLErrorTimedOut:return [NSString stringWithFormat:@"%@ errorCode:%zi",CQNSURLErrorTimedOut,[(NSError*)err code]];break;
                case NSURLErrorCannotFindHost:return [NSString stringWithFormat:@"%@ errorCode:%zi",CQNSURLErrorCannotFindHost,[(NSError*)err code]];break;
                case NSURLErrorCannotConnectToHost:return [NSString stringWithFormat:@"%@ errorCode:%zi",CQNSURLErrorCannotConnectToHost,[(NSError*)err code]];break;
                case NSURLErrorBadServerResponse:return [NSString stringWithFormat:@"%@ errorCode:%zi",CQNSURLErrorBadServerResponse,[(NSError*)err code]];break;
                case NSURLErrorNotConnectedToInternet: return [NSString stringWithFormat:@"%@ errorCode:%zi",CQNSURLErrorNotConnectedToInternet,[(NSError*)err code]];break;
                case NSURLErrorUnsupportedURL: return [NSString stringWithFormat:@"%@ errorCode:%zi",CQNSURLErrorURLErrorUnsupportedURL,[(NSError*)err code]];break;
                case NSURLErrorNetworkConnectionLost : return @"NetworkConnectionLost";
                default:
                    return [NSString stringWithFormat:@"%@ 状态码:%zi ",CQNSURLErrorOtherError,[(NSError*)err code]];
                    break;
            }
        }
        else
        {
            //正式
            switch ([(NSError*)err code])
            {
                case NSURLErrorCancelled:return CQNSURLErrorCancelled;break;
                case NSURLErrorTimedOut:return CQNSURLErrorTimedOut;break;
                case NSURLErrorNotConnectedToInternet: return CQNSURLErrorNotConnectedToInternet;break;
                default:
                    return CQNSURLErrorNetError;
                    break;
            }
            
        }
    }
    else
    {
        return @"";
    }
}
@end
