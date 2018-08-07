//
//  CLPayPwdCheckAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLPayPwdCheckAPI.h"
#import "CLAppContext.h"
#import "NSString+Coding.h"

@interface CLPayPwdCheckAPI () <CLBaseConfigRequest>

@end

@implementation CLPayPwdCheckAPI

- (NSString *)methodName {
    
    return @"check_pay_pwd";
}

- (NSDictionary *)requestBaseParams {
    
    return @{@"cmd":@"check_pay_pwd",@"token":[[CLAppContext context] token],@"pay_pwd":[self.pay_pwd md5]};
}

@end
