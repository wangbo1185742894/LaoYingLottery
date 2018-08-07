//
//  CLRechargeOrderCreateAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CKRechargeOrderCreateAPI.h"

@interface CKRechargeOrderCreateAPI ()

@end

@implementation CKRechargeOrderCreateAPI

- (NSString *)methodName {
    
    return @"create_order_for_fill";
}

- (NSDictionary *)ck_requestBaseParams {
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:@"create_order_for_fill" forKey:@"cmd"];
    if(self.amount)[params setObject:self.amount forKey:@"amount"];
    if(self.need_channels)[params setObject:self.need_channels forKey:@"need_channels"];
    if(self.trading_infos)[params setObject:self.trading_infos forKey:@"trading_infos"];
    if (self.card_no) [params setObject:self.card_no forKey:@"card_no"];
    return params;
}

@end
