//
//  SLSportsCreateOrderRequest.m
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/26.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLSportsCreateOrderRequest.h"

@implementation SLSportsCreateOrderRequest

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
    ;
    
//    3	胜负玩法，胜
//    0	胜负玩法， 负
//    31	胜分差玩法，"主胜1-5"
//    32	胜分差玩法，"主胜6-10"
//    33	胜分差玩法，"主胜11-15"
//    34	胜分差玩法，"主胜16-20"
//    35	胜分差玩法，"主胜21-25"
//    36	胜分差玩法，"主胜26+"
//    self.lotteryNumber = @"20170814301:31:0 20170814302:101:0";
//    self.betTimes = @"1";
//    self.gameId = @"10030";
//    self.gameExtra = @"2_1";
//    self.amount = @"2";
    NSMutableDictionary *bodyDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [bodyDic setValue:self.gameId forKey:@"gameId"];
    [bodyDic setValue:self.betTimes forKey:@"betTimes"];
    [bodyDic setValue:self.amount forKey:@"amount"];
    if (self.gameExtra && self.gameExtra.length > 0) {
//        [bodyDic setValue:self.gameExtra forKey:@"gameExtra"];
        [bodyDic setValue:[NSString stringWithFormat:@"%@@%@@%@",self.lotteryNumber,self.gameExtra,self.betTimes] forKey:@"lotteryNumber"];
    }
    [bodyDic setValue:@"1" forKey:@"client"];
    return bodyDic;
}

@end
