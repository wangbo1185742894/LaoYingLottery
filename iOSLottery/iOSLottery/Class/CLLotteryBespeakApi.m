//
//  CLLotteryBespeakApi.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLLotteryBespeakApi.h"

@implementation CLLotteryBespeakApi


- (instancetype) init {
    
    self = [super init];
    if (self ) {
        
    }
    return self;
}
- (NSTimeInterval)requestTimeoutInterval {
    
    return 7.f;
}

- (NSString *)requestBaseUrlSuffix {
    
    return @"/order/postName";
}
- (NSDictionary *)requestBaseParams{
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:self.order_Id forKey:@"orderId"];
    return params;
}

@end
