//
//  CLPersonalMsgAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/22.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLPersonalMsgAPI.h"
#import "CLAPI.h"

#import "CLAppContext.h"

@interface CLPersonalMsgAPI () <CLBaseConfigRequest>

@end

@implementation CLPersonalMsgAPI

- (NSString *)methodName {
    
    return @"personalMessage";
}

- (NSDictionary *)requestBaseParams {

    if ([CLAppContext context].token) {
        return @{@"cmd":CMD_UserPersonalMessageAPI,
                 @"token":[CLAppContext context].token};
    }else{
        return @{@"cmd":CMD_UserPersonalMessageAPI,
                 @"token":@""};
    }
}

@end
