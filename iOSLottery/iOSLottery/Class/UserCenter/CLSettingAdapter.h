//
//  CLSettingAdapter.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/18.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLSettingAdapter : NSObject

+ (void) updateFreePayPwdAmount:(long long)amount;

+ (void) updateFreePayPwdStatus:(BOOL)status;

+ (void) updatePayPwdStatus:(BOOL)status;

+ (void) updateLoginPwdStatus:(BOOL)status;


+ (long long) getFreePayPwdAmount;

+ (BOOL) getFreePayPwdStatus;

+ (BOOL) hasPayPwdStatus;

+ (BOOL) hasLoginPwdStatus;

@end
