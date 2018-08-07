//
//  CLAddBankCardAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/5.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLAddBankCardAPI.h"
#import "CLAPI.h"
#import "CLAppContext.h"

@interface CLAddBankCardAPI () <CLBaseConfigRequest>



@end

@implementation CLAddBankCardAPI

- (NSString *)methodName {
    
    return @"get_card_bin_by_bank_card";
}

- (NSDictionary *)requestBaseParams {
    
    NSMutableDictionary* apiDict = [NSMutableDictionary dictionaryWithCapacity:5];
    [apiDict setObject:CMD_GetBankCardBinInfoAPI forKey:@"cmd"];
    [apiDict setObject:[CLAppContext context].token forKey:@"token"];
    [apiDict setObject:self.bankCardNO forKey:@"card_no"];
    if (self.type) [apiDict setObject:self.type forKey:@"type"];
    if (self.account_type_id) [apiDict setObject:self.account_type_id forKey:@"account_type_id"];
    
    return apiDict;
}

@end
