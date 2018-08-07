//
//  CLRedEnveOrderCreateAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CKRedEnveOrderCreateAPI.h"
#import "CKPayClient.h"
@interface CKRedEnveOrderCreateAPI ()

@end

@implementation CKRedEnveOrderCreateAPI

- (NSString *)methodName {
    
    return @"create_order_for_red";
}

- (NSDictionary *)ck_requestBaseParams {
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:@"create_order_for_red_new" forKey:@"cmd"];
    if(self.amount)[params setObject:self.amount forKey:@"amount"];
    if(self.need_channels_id)[params setObject:self.need_channels_id forKey:@"account_type_id"];
    if(self.pre_handle_token)[params setObject:self.pre_handle_token forKey:@"pre_handle_token"];
    if(self.card_no)[params setObject:self.card_no forKey:@"card_no"];
    if ([[CKPayClient sharedManager].intermediary pay_version]) {
        [params setObject:[[CKPayClient sharedManager].intermediary pay_version] forKey:@"pay_version"];
    }
    return params;
}

@end
