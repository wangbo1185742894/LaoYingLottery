//
//  CLRechargeOrderCreateAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLRechargeOrderCreateAPI.h"
#import "CLAppContext.h"
@interface CLRechargeOrderCreateAPI () <CLBaseConfigRequest>

@end

@implementation CLRechargeOrderCreateAPI

- (NSString *)methodName {
    
    return @"create_order_for_fill";
}

- (NSDictionary *)requestBaseParams {
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:@"create_order_for_fill" forKey:@"cmd"];
    [params setObject:[[CLAppContext context] token] forKey:@"token"];
    [params setObject:self.amount forKey:@"amount"];
    [params setObject:self.need_channels forKey:@"need_channels"];
    [params setObject:self.trading_infos forKey:@"trading_infos"];
    if (self.card_no) [params setObject:self.card_no forKey:@"card_no"];
    return params;
}

@end
