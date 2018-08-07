//
//  CLLotteryOnlyThirdPayAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CKLotteryAccountAndThirdPayAPI.h"

@interface CKLotteryAccountAndThirdPayAPI ()

@end

@implementation CKLotteryAccountAndThirdPayAPI

- (NSString *)methodName {
    
    return @"";
}

- (NSDictionary *)ck_requestBaseParams {
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:@"account_get_third_token_cash_group" forKey:@"cmd"];
    if(self.amount)[params setObject:self.amount forKey:@"amount"];
    if(self.pre_handle_token)[params setObject:self.pre_handle_token forKey:@"pre_handle_token"];
    if(self.fid)[params setObject:self.fid forKey:@"fid"];
    if(self.red_amount)[params setObject:self.red_amount forKey:@"red_amount"];
    if(self.account_type_id)[params setObject:self.account_type_id forKey:@"account_type_id"];
    if(self.account_amount)[params setObject:self.account_amount forKey:@"account_amount"];
    if (self.card_no) [params setObject:self.card_no forKey:@"card_no"];
    return params;
}

@end
