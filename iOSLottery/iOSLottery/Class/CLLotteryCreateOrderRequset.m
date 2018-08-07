//
//  CLLotteryCreateOrderRequset.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/10.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLLotteryCreateOrderRequset.h"


@interface CLLotteryCreateOrderRequset () <CLBaseConfigRequest>

@end
@implementation CLLotteryCreateOrderRequset

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
    
    return @"/order/normalOrder";
}
- (NSDictionary *)requestBaseParams{
    
     //http：//localhost：8080/order/normalOrder？token=userToken&gameId=19511&periodId=201611090001&betTimes=2&lotteryNumber=12_13_14[HEZHI],SAME_3_ALL[SAME_3_ALL],4 5 6[DIFF_3],1 2 3 5 6[DIFF_3]&amount=60&client=1
//    NSLog(@"%@", self.gameId);
//    NSLog(@"%@", self.periodId);
//    NSLog(@"%@", self.betTimes);
//    NSLog(@"%@", self.lotteryNumber);
//    NSLog(@"%@", self.amount);
    
    NSMutableDictionary *bodyDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [bodyDic setValue:self.gameId forKey:@"gameId"];
    [bodyDic setValue:self.periodId forKey:@"periodId"];
    [bodyDic setValue:self.betTimes forKey:@"betTimes"];
    [bodyDic setValue:self.lotteryNumber forKey:@"lotteryNumber"];
    [bodyDic setValue:self.amount forKey:@"amount"];
    if (self.gameExtra && self.gameExtra.length > 0) {
        [bodyDic setValue:self.gameExtra forKey:@"gameExtra"];
    }
    [bodyDic setValue:@"1" forKey:@"client"];
    return bodyDic;
}

@end
