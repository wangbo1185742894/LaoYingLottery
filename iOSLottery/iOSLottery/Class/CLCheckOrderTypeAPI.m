//
//  CLCheckOrderTypeAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/26.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLCheckOrderTypeAPI.h"
#import "CLAppContext.h"
@interface CLCheckOrderTypeAPI () <CLBaseConfigRequest>

@end

@implementation CLCheckOrderTypeAPI

- (NSString *)methodName {
    
    return @"/checkOrderType";
}

- (NSString*)requestBaseUrlSuffix {
    
    return @"/checkOrderType";
}

- (NSDictionary *)requestBaseParams {
    
    return @{@"orderId":self.orderId, @"channel": [CLAppContext channelId]};
}

- (OrderType) orderTypeForDict:(NSDictionary*)dict {
    
    id type = dict[@"orderType"];
    self.skipUrl = dict[@"downloadUrl"];
    self.ifSkipDownload = [dict[@"ifSkipDownload"] integerValue];
    self.bulletTips = dict[@"bulletTips"];
    NSInteger gameType = [dict[@"gameType"]?:@"" integerValue];
    if (gameType > 0) {
        self.gameType = gameType;
    }

    if (![type isKindOfClass:[NSNull class]]) {
        if ([type integerValue] == 1) {
            return OrderTypeNormal;
        } else if ([type integerValue] == 2) {
            return OrderTypeFollow;
        }
    }
    
    return -1;
    
}

@end
