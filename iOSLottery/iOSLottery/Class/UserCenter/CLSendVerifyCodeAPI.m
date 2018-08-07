//
//  CLSendVerifyCodeAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/24.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLSendVerifyCodeAPI.h"
#import "CLAPI.h"


@interface CLSendVerifyCodeAPI () <CLBaseConfigRequest>

@end

@implementation CLSendVerifyCodeAPI

- (NSString *)methodName {
    
    return @"sendVerifyCode";
}

- (NSDictionary *)requestBaseParams {
    
    return @{@"cmd":CMD_sendVerifyCodeAPI,
             @"mobile":self.mobile};
}


@end
