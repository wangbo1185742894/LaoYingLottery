//
//  CLSetLoginPwdAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/18.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLSetLoginPwdAPI.h"
#import "CLAppContext.h"

@interface CLSetLoginPwdAPI () <CLBaseConfigRequest>

@end

@implementation CLSetLoginPwdAPI

- (NSString *)methodName {
    
    return @"create_pwd";
}

- (NSDictionary *)requestBaseParams {
    
    return @{@"cmd":@"create_pwd",
             @"token":[[CLAppContext context] token]};
}

@end
