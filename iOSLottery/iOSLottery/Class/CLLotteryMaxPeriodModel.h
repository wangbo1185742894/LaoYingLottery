//
//  CLLotteryMaxPeriodModel.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/12.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

@interface CLLotteryMaxPeriodModel : CLBaseModel

@property (nonatomic, strong) NSArray *periodVos;
@property (nonatomic, assign) long maxBetTimes;
@property (nonatomic, assign) long todayPeriods;

@end
