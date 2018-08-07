//
//  CLNetworkService.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLNetworkService.h"
#import "CLBaseRequest.h"


@implementation CLNetworkService

+ (NSString*) requestUrlAssisgnmentWith:(CLBaseRequest*)request {
    
    NSString* url = @"";
    if (request.paramSource && [request.paramSource respondsToSelector:@selector(urlSuffixForApi:)]) {
        url = [NSString stringWithFormat:@"%@%@",url,[request.paramSource urlSuffixForApi:request]];
    } else {
        if ([request.child respondsToSelector:@selector(requestBaseUrlSuffix)]) {
            url = [NSString stringWithFormat:@"%@%@",url,[request.child requestBaseUrlSuffix]];
        }
    }
    return url;
}


+ (NSDictionary*) requestParamsAssignmentWith:(CLBaseRequest*)request {
    
    NSMutableDictionary* dict = [request.isRequestParams mutableCopy];
    
    //添加时间戳、api版本号
    NSDate* dateNew =  [NSDate date];
    NSTimeInterval time = [dateNew timeIntervalSince1970];
    long long int date = (long long int)time;
    [dict setObject:[NSString stringWithFormat:@"%lld",date] forKey:@"caiqr_timestamp"];
    [dict setValue:@"1.2" forKey:@"caiqr_version"];
//    NSString *token = [[CLAppContext context] token];
//    if (token && token.length > 0) {
//        [dict setValue:token forKey:@"token"];
//    }
    
    //追加附加body信息
    if (request.baseUrlConfig && [request.baseUrlConfig respondsToSelector:@selector(paramsAdditional:)]) {
        [dict addEntriesFromDictionary:[request.baseUrlConfig paramsAdditional:request]];
    }
    
    return dict;
}

@end
