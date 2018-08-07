//
//  CLRedEnveExchangeAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/29.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLRedEnveExchangeAPI.h"
#import "CLAPI.h"

@interface CLRedEnveExchangeAPI () <CLBaseConfigRequest>

@end

@implementation CLRedEnveExchangeAPI

- (NSString *)methodName {
    
    return @"red_exchange_redeem_code";
}

- (NSDictionary *)requestBaseParams {
    
    return @{@"cmd":CMD_RedEnvelopExchangeAPI,
             @"token":@"",
             @"redeem_code":self.redeem_code};
}

@end
