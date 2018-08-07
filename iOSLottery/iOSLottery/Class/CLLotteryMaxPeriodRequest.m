//
//  CLLotteryMaxPeriodRequest.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/12.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLLotteryMaxPeriodRequest.h"

@implementation CLLotteryMaxPeriodRequest

- (NSString *)requestBaseUrlSuffix{
    
    return [NSString stringWithFormat:@"/bet/follow/%@", self.gameEn];
}

@end
