//
//  NSError+CQError.h
//  caiqr
//
//  Created by 彩球 on 15/9/18.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (CQError)

- (NSDictionary*)responseData;

- (NSHTTPURLResponse*)httpUrlResponse;

- (NSInteger)httpStatusCode;

@end
