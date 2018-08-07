//
//  CLRedEnveOrderCreateAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLRedEnveOrderCreateAPI.h"
#import "CLAppContext.h"

@interface CLRedEnveOrderCreateAPI () <CLBaseConfigRequest>

@end

@implementation CLRedEnveOrderCreateAPI

- (NSString *)methodName {
    
    return @"create_order_for_red";
}

- (NSDictionary *)requestBaseParams {
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:@"create_order_for_red" forKey:@"cmd"];
    [params setObject:[[CLAppContext context] token] forKey:@"token"];
    [params setObject:self.amount forKey:@"amount"];
    [params setObject:self.need_channels forKey:@"need_channels"];
    [params setObject:self.trading_infos forKey:@"trading_infos"];
    [params setObject:self.red_program_id forKey:@"red_program_id"];
    if (self.card_no) [params setObject:self.card_no forKey:@"card_no"];
    return params;
}

@end
