//
//  CLATCreateOrderRequset.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/19.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLATCreateOrderRequset.h"

@implementation CLATCreateOrderRequset

- (NSString *)requestBaseUrlSuffix {
    
    return @"/order/normalOrder";
}

- (NSDictionary *)requestBaseParams
{

    NSMutableDictionary *bodyDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [bodyDic setValue:self.gameId forKey:@"gameId"];
    [bodyDic setValue:self.periodId forKey:@"periodId"];
    [bodyDic setValue:self.betTimes forKey:@"betTimes"];
    [bodyDic setValue:self.amount forKey:@"amount"];
    [bodyDic setValue:self.lotteryNumber forKey:@"lotteryNumber"];
//    if (self.gameExtra && self.gameExtra.length > 0) {
//        //        [bodyDic setValue:self.gameExtra forKey:@"gameExtra"];
//        [bodyDic setValue:[NSString stringWithFormat:@"%@@%@@%@",self.lotteryNumber,self.gameExtra,self.betTimes] forKey:@"lotteryNumber"];
//    }
    [bodyDic setValue:@"1" forKey:@"client"];
    return bodyDic;
    
}

@end
