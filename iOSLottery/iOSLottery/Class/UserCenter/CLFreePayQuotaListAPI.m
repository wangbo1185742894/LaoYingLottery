//
//  CLFreePayQuotaListAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/18.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFreePayQuotaListAPI.h"

@interface CLFreePayQuotaListAPI () <CLBaseConfigRequest>

@end

@implementation CLFreePayQuotaListAPI

- (NSString *)methodName {
    
    return @"show_free_pay_pwd_quota_list";
}

- (NSDictionary *)requestBaseParams {
    
    return @{@"cmd":@"show_free_pay_pwd_quota_list"};
}

@end
