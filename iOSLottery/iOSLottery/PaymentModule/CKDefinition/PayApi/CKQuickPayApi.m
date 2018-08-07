//
//  CQQuickPayApi.m
//  caiqr
//
//  Created by 小铭 on 2017/4/27.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKQuickPayApi.h"
#import "CKPayClient.h"
@implementation CKQuickPayApi

- (NSDictionary *)ck_requestBaseParams
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [dict setObject:@"get_pay_for_list_has_pre_token_cash" forKey:@"cmd"];
    if([[CKPayClient sharedManager].intermediary token])[dict setObject:[[CKPayClient sharedManager].intermediary token] forKey:@"token"];
    [dict setObject:@"1" forKey:@"quick_bet"];
    if(self.preHandleToken)[dict setObject:self.preHandleToken forKey:@"pre_handle_token"];
    if ([[CKPayClient sharedManager].intermediary pay_version]) {
        [dict setObject:[[CKPayClient sharedManager].intermediary pay_version] forKey:@"pay_version"];
    }
    return dict;
}

@end
