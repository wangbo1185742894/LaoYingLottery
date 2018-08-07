//
//  CLSettingAdapter.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/18.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLSettingAdapter.h"
#import "CLAppContext.h"
#import "CLUserBaseInfo.h"

@implementation CLSettingAdapter

+ (void) updateFreePayPwdAmount:(long long)amount {
    
    [CLAppContext context].userMessage.user_info.free_pay_pwd_quota = amount;
}

+ (void) updateFreePayPwdStatus:(BOOL)status {
    
    [CLAppContext context].userMessage.user_info.free_pay_pwd_status = status;
}

+ (void) updatePayPwdStatus:(BOOL)status {
    
    [CLAppContext context].userMessage.user_info.has_pay_pwd = status;
}

+ (void) updateLoginPwdStatus:(BOOL)status {
    
    [CLAppContext context].userMessage.user_info.has_pwd = status;
}


+ (long long) getFreePayPwdAmount {
    
    return [CLAppContext context].userMessage.user_info.free_pay_pwd_quota;
}

+ (BOOL) getFreePayPwdStatus {
    
    return [CLAppContext context].userMessage.user_info.free_pay_pwd_status;
}

+ (BOOL) hasPayPwdStatus {
    
    return [CLAppContext context].userMessage.user_info.has_pay_pwd;
}

+ (BOOL) hasLoginPwdStatus {
    
    return [CLAppContext context].userMessage.user_info.has_pwd;
}

@end
