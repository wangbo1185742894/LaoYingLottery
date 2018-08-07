//
//  NSString+Legitimacy.h
//  caiqr
//
//  Created by 彩球 on 16/8/11.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Legitimacy)

/*
 *  判断字符串是不是都是空格
 */
- (BOOL)isEmptyString;

/** 判断是否是数字 */
- (BOOL)isPureNumandCharacters;

/** 检测银行卡合法性 */
- (BOOL)checkBankCardNumberValid;

/** 检测身份证号合法性 */
- (BOOL)checkIDCardNumberValid;


/** 判断字符串只能是数字、字母或数字字母组合 (是否是6-15位) */
- (BOOL)checkDomainOfCharAndNum;

/** 用户昵称合法性校验 */
- (BOOL)checkDomainOfUserNickName;

/** 手机号合法性校验 */
- (BOOL)checkTelephoneValid;

/** 判断字符串是否只有数字和英文*/
- (BOOL)checkStringIsOnlyHasNumberAndEnglish;

/** 判断字符串是否只有数字*/
- (BOOL)checkStringIsOnlyHasNumber;

@end
