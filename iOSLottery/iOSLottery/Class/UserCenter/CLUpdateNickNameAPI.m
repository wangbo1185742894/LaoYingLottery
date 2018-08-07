//
//  CLUpdateNickNameAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/23.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLUpdateNickNameAPI.h"
#import "CLAppContext.h"

@interface CLUpdateNickNameAPI () <CLBaseConfigRequest>

@end

@implementation CLUpdateNickNameAPI

- (NSString *)methodName {
    
    return @"updateNickNameAPI";
}

- (NSDictionary *)requestBaseParams {
    
    return @{@"cmd":@"user_nick_name_change",
             @"token":[[CLAppContext context] token]};
}

@end
