//
//  CLWithdrawCashAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLWithdrawCashAPI.h"
#import "CLAPI.h"
#import "CLAppContext.h"
#import "MJExtension.h"
@interface CLWithdrawCashAPI () <CLBaseConfigRequest>

@end

@implementation CLWithdrawCashAPI

- (NSString *)methodName {
    
    return @"CMD_CreateWithDrawOrderAPI";
}

- (NSDictionary *)requestBaseParams {
    
    return @{@"cmd":CMD_CreateWithDrawOrderAPI,
             @"amount":self.amount,
             @"channel_type":self.channel_type,
             @"channel_info":[@[self.channel_info] mj_JSONString]};
}

@end
