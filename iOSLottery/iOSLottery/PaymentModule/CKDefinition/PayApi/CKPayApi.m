//
//  CKPayApi.m
//  caiqr
//
//  Created by huangyuchen on 2017/4/27.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKPayApi.h"
#import "CKPayClient.h"
@implementation CKPayApi


- (NSDictionary *)ck_requestBaseParams{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];

    [dict setObject:@"get_pay_for_list_has_pre_token_cash" forKey:@"cmd"];
//    [dict setObject:self.token forKey:@"token"];
    if ([[CKPayClient sharedManager].intermediary token] && [[CKPayClient sharedManager].intermediary token].length > 0) {
        [dict setObject:[[CKPayClient sharedManager].intermediary token] forKey:@"token"];
    }
    if (self.preHandleToken && self.preHandleToken.length) {
        [dict setObject:self.preHandleToken forKey:@"pre_handle_token"];
    }
    if ([[CKPayClient sharedManager].intermediary pay_version]) {
        [dict setObject:[[CKPayClient sharedManager].intermediary pay_version] forKey:@"pay_version"];
    }
    return dict;
}

@end
