//
//  CKPayRedApi.m
//  caiqr
//
//  Created by huangyuchen on 2017/5/3.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKPayRedApi.h"
#import "CKPayClient.h"
@implementation CKPayRedApi

- (NSDictionary *)ck_requestBaseParams{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [dict setObject:@"get_pay_for_list_has_pre_token_cash_for_red" forKey:@"cmd"];
    if ([[CKPayClient sharedManager].intermediary token] && [[CKPayClient sharedManager].intermediary token].length > 0) {
        [dict setObject:[[CKPayClient sharedManager].intermediary token] forKey:@"token"];
    }
    if(self.preHandleToken && self.preHandleToken.length)[dict setObject:self.preHandleToken forKey:@"pre_handle_token"];
    if ([[CKPayClient sharedManager].intermediary pay_version]) {
        [dict setObject:[[CKPayClient sharedManager].intermediary pay_version] forKey:@"pay_version"];
    }
    return dict;
}

@end
