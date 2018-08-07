//
//  CLLotteryChaseOrderRequest.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/20.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLLotteryChaseOrderRequest.h"

@implementation CLLotteryChaseOrderRequest

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
    
    return @"/follow/followBuyOrder";
}
- (NSDictionary *)requestBaseParams{
    
//    NSLog(@"%@", self.gameId);
//    NSLog(@"%@", self.lotteryNumber);
//    NSLog(@"%@", self.amount);
//    NSLog(@"%@", self.followMode);
//    NSLog(@"%@", self.totalPeriod);
//    NSLog(@"%@", self.periodTimesStr);
//    NSLog(@"%@", self.followType);
    
    NSMutableDictionary *bodyDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [bodyDic setValue:self.gameId forKey:@"gameId"];
    [bodyDic setValue:self.lotteryNumber forKey:@"lotteryNumber"];
    [bodyDic setValue:self.amount forKey:@"amount"];
    [bodyDic setValue:self.followMode forKey:@"followMode"];
    [bodyDic setValue:self.totalPeriod forKey:@"totalPeriod"];
    [bodyDic setValue:self.periodTimesStr forKey:@"periodTimesStr"];
    [bodyDic setValue:self.followType forKey:@"followType"];
    if (self.gameExtra && self.gameExtra.length > 0) {
        [bodyDic setValue:self.gameExtra forKey:@"gameExtra"];
    }
    [bodyDic setValue:@"1" forKey:@"client"];
    return bodyDic;
}

@end
