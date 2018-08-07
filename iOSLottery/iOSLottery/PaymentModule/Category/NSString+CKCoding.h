//
//  NSString+CKCoding.h
//  caiqr
//
//  Created by 小铭 on 2017/5/4.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CKCoding)

- (NSString*)ck_nativeUrlEncode;

- (NSString *)ck_nativeUrlDecode;

- (NSString *)base64;

@end
