//
//  CLBindMobileAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/24.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBindMobileAPI.h"
#import "CLAPI.h"

@interface CLBindMobileAPI () <CLBaseConfigRequest>

@end

@implementation CLBindMobileAPI

- (NSString *)methodName {
    
    return @"bindUserMobile";
}

- (NSDictionary *)requestBaseParams {
    
    return @{@"cmd":CMD_BindUserMobileAPI,
             @"token":@"",
             @"mobile":self.mobile,
             @"verify_code":self.verifyCode};
}

@end
