//
//  CLModifyPayPwdAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/30.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLModifyPayPwdAPI.h"
#import "CLAPI.h"
#import "CLAppContext.h"

@interface CLModifyPayPwdAPI () <CLBaseConfigRequest>

@end

@implementation CLModifyPayPwdAPI


- (NSString *)methodName {
    
    
    return @"modify_paymeng_password";
}

- (NSDictionary *)requestBaseParams {
    
    
    return @{@"cmd":CMD_ModifyPayPwdAPI,
             @"token":[[CLAppContext context] token]};
}

@end
