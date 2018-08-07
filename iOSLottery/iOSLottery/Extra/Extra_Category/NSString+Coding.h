//
//  NSString+Coding.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/3.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Coding)

/** md5 */

- (NSString *)md5;

/** base64 decodeBase64 ...  */

- (NSString *)base64;
- (NSString *)decodeBase64;

/** url encode decode ... */
- (NSString *)urlEncode;
- (NSString *)urlDecode;


/* 随机产生5个字母 */
+ (NSString *)retbitStringCount:(NSInteger)count;

@end
