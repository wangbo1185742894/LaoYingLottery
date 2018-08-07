//
//  CLUrlResponse.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/8.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLUrlResponse : NSObject

@property (nonatomic, readonly) NSInteger status;
@property (nonatomic, copy, readonly) NSHTTPURLResponse *httpUrlResponse;
@property (nonatomic, copy, readonly) id responseObject;
@property (nonatomic, copy, readonly) NSError *error;
@property (nonatomic, readonly) NSInteger dataCode;
@property (nonatomic, copy, readonly) id resp;
@property (nonatomic, readonly) BOOL success;
@property (nonatomic, strong, readonly) NSString* errorMessage;
- (instancetype) initWithResponseDataTask:(NSURLSessionTask*)dataTask object:(id)responseObject status:(NSInteger)status;

- (instancetype) initWithResponseDataTask:(NSURLSessionTask*)dataTask errpr:(NSError*)error;

@end
