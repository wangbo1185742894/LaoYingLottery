//
//  CLBankCardReliveAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/2.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBankCardReliveAPI.h"
#import "CLAPI.h"
#import "CLAppContext.h"

@interface CLBankCardReliveAPI () <CLBaseConfigRequest>

@property (nonatomic, strong) NSMutableDictionary* params;

@end

@implementation CLBankCardReliveAPI

- (NSString *)methodName {
    
    return @"UserReliveBankCardAPI";
}

- (NSDictionary *)requestBaseParams {
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
    if (params.count > 0)  [params removeAllObjects];
    [params addEntriesFromDictionary:self.bankCardInfo];
    [params setObject:CMD_UserReliveBankCardAPI forKey:@"cmd"];
    [params setObject:@"3" forKey:@"channel_type"];
    [params setObject:[[CLAppContext context] token] forKey:@"token"];
    
    return params;
}
@end
