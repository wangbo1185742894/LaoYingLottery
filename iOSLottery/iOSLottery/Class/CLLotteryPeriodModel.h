//
//  CLLotteryPeriodModel.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/17.
//  Copyright © 2016年 caiqr. All rights reserved.
//
// 所有彩种当前期次的信息和截止时间
#import "CLBaseModel.h"

@interface CLLotteryPeriodModel : CLBaseModel

@property (nonatomic, strong) NSString *periodId;
@property (nonatomic, assign) long saleEndTime;
@property (nonatomic, strong) NSString *gameEn;
@property (nonatomic, strong) NSString *gameId;
@property (nonatomic, strong) NSString *gameName;
@property (nonatomic, strong) NSString *maxBetTimes;
/**
 "periodId":"20160926003",//期次id
 "saleEndTime":500,//当前期次停止售卖剩余时间（秒）
 "gameEn":"shKuai3",//彩种英文名
 "gameId":"2"//彩种Id
 */
@end
