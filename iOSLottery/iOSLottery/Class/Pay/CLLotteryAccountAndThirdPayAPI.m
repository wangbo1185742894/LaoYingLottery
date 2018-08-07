//
//  CLLotteryOnlyThirdPayAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLLotteryAccountAndThirdPayAPI.h"
#import "CLAppContext.h"

@interface CLLotteryAccountAndThirdPayAPI () <CLBaseConfigRequest>

@end

@implementation CLLotteryAccountAndThirdPayAPI

- (NSString *)methodName {
    
    return @"";
}

- (NSDictionary *)requestBaseParams {
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:@"account_get_third_token_cash_group" forKey:@"cmd"];
    [params setObject:[[CLAppContext context] token] forKey:@"token"];
    [params setObject:self.amount forKey:@"amount"];
    [params setObject:self.pre_handle_token forKey:@"pre_handle_token"];
    [params setObject:self.fid forKey:@"fid"];
    [params setObject:self.red_amount forKey:@"red_amount"];
    [params setObject:self.account_type_id forKey:@"account_type_id"];
    [params setObject:self.account_amount forKey:@"account_amount"];
    if (self.card_no) [params setObject:self.card_no forKey:@"card_no"];
    return params;
}

@end
