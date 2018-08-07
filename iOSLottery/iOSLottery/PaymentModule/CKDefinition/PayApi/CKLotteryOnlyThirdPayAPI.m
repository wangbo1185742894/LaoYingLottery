//
//  CLLotteryOnlyThirdPayAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CKLotteryOnlyThirdPayAPI.h"


@interface CKLotteryOnlyThirdPayAPI ()

@end

@implementation CKLotteryOnlyThirdPayAPI

- (NSString *)methodName {
    
    return @"";
}

- (NSDictionary *)ck_requestBaseParams {
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:@"account_get_third_token_cash_only_pay" forKey:@"cmd"];
    
    if (self.amount && self.amount > 0) {
        [params setObject:self.amount forKey:@"amount"];
    }
    if (self.pre_handle_token && self.pre_handle_token.length > 0) {
        [params setObject:self.pre_handle_token forKey:@"pre_handle_token"];
    }
    if (self.account_type_id && self.account_type_id.length > 0) {
        [params setObject:self.account_type_id forKey:@"account_type_id"];
    }
    if (self.card_no) [params setObject:self.card_no forKey:@"card_no"];
    return params;
}

@end
