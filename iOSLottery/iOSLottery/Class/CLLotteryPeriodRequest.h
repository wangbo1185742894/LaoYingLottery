//
//  CLLotteryPeriodRequest.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/17.
//  Copyright © 2017年 caiqr. All rights reserved.
//
//指定彩种的售卖期次

#import "CLLotteryBusinessRequest.h"

@interface CLLotteryPeriodRequest : CLLotteryBusinessRequest<CLBaseConfigRequest>

@property (nonatomic, strong) NSString *gameEn;

@end
