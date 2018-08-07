//
//  NSError+CQError.m
//  caiqr
//
//  Created by 彩球 on 15/9/18.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "NSError+CQError.h"

@implementation NSError (CQError)

- (NSDictionary*)responseData
{
    id jsonData = [self.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
    if ([jsonData isKindOfClass:[NSData class]]) {
        NSDictionary* jsonDictionary = [NSJSONSerialization  JSONObjectWithData:jsonData options:0 error:nil];
        return jsonDictionary;
    }
    return nil;
}

- (NSHTTPURLResponse*)httpUrlResponse
{
    id response = [self.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"];
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        return (NSHTTPURLResponse*)response;
    }
    return nil;
}

- (NSInteger)httpStatusCode
{
    NSHTTPURLResponse* httpResponse = [self httpUrlResponse];
    if (httpResponse) {
        return httpResponse.statusCode;
    }
    return -1;
}


@end
