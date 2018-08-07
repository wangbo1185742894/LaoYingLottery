//
//  CLLotteryMainBetModel.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/22.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"
#import "CLLotteryBonusNumModel.h"
#import "CLLotteryPeriodModel.h"
#import "CLLotteryActivitiesModel.h"

@class CLDLTActivityModel;

@interface CLLotteryMainBetModel : CLBaseModel

@property (nonatomic, strong) CLLotteryPeriodModel *currentPeriod;
@property (nonatomic, strong) CLLotteryBonusNumModel *lastAwardInfo;
@property (nonatomic, strong) NSArray *awardInfoVos;
@property (nonatomic, strong) NSMutableDictionary *awardInfoMap;
@property (nonatomic, strong) NSString *currentSubPeriod;
@property (nonatomic, strong) NSString *lastSubPeriod;
@property (nonatomic, assign) long periodAllTime;

@property (nonatomic, strong) CLLotteryActivitiesModel *activityMap;
@property (nonatomic, strong) NSArray *extraBackground;//玩法加奖图标
@property (nonatomic, strong) NSArray *awardBonus;//奖金信息
@property (nonatomic, assign) NSInteger ifAuditing;



//大乐透 双色球使用
@property (nonatomic, strong) NSString *betEndInfo;
@property (nonatomic, strong) NSString *beiTou;
@property (nonatomic, strong) NSString *poolBonus;
//遗漏
@property (nonatomic, strong) NSDictionary *missingNumbers;

@end
