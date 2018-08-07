//
//  CLPayPwdSettingAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLPayPwdSettingAPI.h"
#import "CLAppContext.h"
#import "NSString+Coding.h"

@interface CLPayPwdSettingAPI () <CLBaseConfigRequest>

@end

@implementation CLPayPwdSettingAPI

- (NSString *)methodName {
    
    return @"check_pay_pwd";
}

- (NSDictionary *)requestBaseParams {
    
    return @{@"cmd":@"create_pay_pwd",@"token":[[CLAppContext context] token],
             @"pay_pwd":[self.pay_pwd md5],
             @"re_pay_pwd":[self.pay_pwd md5]};
}

@end
