//
//  CLSetFreePayQuotaAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/18.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLSetFreePayQuotaAPI.h"
#import "CLAppContext.h"

@interface CLSetFreePayQuotaAPI () <CLBaseConfigRequest>

@end

@implementation CLSetFreePayQuotaAPI

- (NSString *)methodName {
    
    return @"set_user_free_pay_pwd_quota";
}

- (NSDictionary *)requestBaseParams {
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:2];
    [params setObject:@"set_user_free_pay_pwd_quota" forKey:@"cmd"];
    [params setObject:[[CLAppContext context] token] forKey:@"token"];
    
    if (self.is_click.length > 0) {
        if ([self.is_click isEqualToString:@"1"]) {
            //不开通 只传token 是否点叉 是否不再提醒
            [params setObject:self.is_click forKey:@"is_click"];
        }else{
            //开通 传 额度，免密开关
            [params setObject:self.free_pay_amount forKey:@"free_pay_pwd_quota"];
            [params setObject:self.free_pay_status forKey:@"free_pay_pwd_status"];
        }
        [params setObject:self.neverNotify forKey:@"never_notify"];
    }else{
        
        [params setObject:self.free_pay_amount forKey:@"free_pay_pwd_quota"];
        [params setObject:self.free_pay_status forKey:@"free_pay_pwd_status"];
    }
    return params;
}

@end
