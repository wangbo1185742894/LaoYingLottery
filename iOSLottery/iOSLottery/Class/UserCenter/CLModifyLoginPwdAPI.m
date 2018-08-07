//
//  CLModifyLoginPwdAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/30.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLModifyLoginPwdAPI.h"
#import "CLAPI.h"
#import "CLAppContext.h"

@interface CLModifyLoginPwdAPI () <CLBaseConfigRequest>

@end

@implementation CLModifyLoginPwdAPI


- (NSString *)methodName {
    
    
    return @"CMD_ModifyLoginPwdAPI";
}

- (NSDictionary *)requestBaseParams {
    
    
    return @{@"cmd":CMD_ModifyLoginPwdAPI,
             @"token":[[CLAppContext context] token]};
}

@end
