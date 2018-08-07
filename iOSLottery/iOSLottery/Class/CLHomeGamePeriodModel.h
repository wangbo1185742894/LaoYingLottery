//
//  CLHomeGamePeriodModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/10.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

@interface CLHomeGamePeriodModel : CLBaseModel

/**
 彩种英文名
 */
@property (nonatomic, strong) NSString* gameEn;

/**
 期次
 */
@property (nonatomic, strong) NSString* periodId;

/**
 当前期次停售时间
 */
@property (nonatomic) long saleEndTime;

/**
 彩种id
 */
@property (nonatomic) long gameId;

/**
 彩种名
 */
@property (nonatomic, strong) NSString *gameName;

/**
 彩种最大投注倍数
 */
@property (nonatomic, assign) long maxBetTimes;

@end
