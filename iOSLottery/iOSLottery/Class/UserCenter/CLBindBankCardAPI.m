//
//  CLBindBankCardAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/5.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBindBankCardAPI.h"
#import "CLAPI.h"

#import "CLAppContext.h"

@interface CLBindBankCardAPI () <CLBaseConfigRequest>

@end

@implementation CLBindBankCardAPI

- (NSString *)methodName {
    
    return @"CMD_BindBankCardAPI";
}

- (NSDictionary *)requestBaseParams {
    
    if (self.bankCardBinDict) {
        
        NSMutableDictionary* params = [self.bankCardBinDict mutableCopy];
        [params setObject:CMD_BindBankCardAPI forKey:@"cmd"];
        [params setObject:[CLAppContext context].token forKey:@"token"];
        [params setObject:self.mobile forKey:@"mobile"];
        [params setObject:self.certifyCode forKey:@"verify_code"];
        [params setObject:@"3" forKey:@"channel_type"];
        [params setObject:params[@"bank_short_name"] forKey:@"sub_bank_name"];
        
        return params;
    }
    
    return nil;
}

@end
