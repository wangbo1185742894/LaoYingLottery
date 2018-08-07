//
//  CLLotteryBetDetailPeriodModel.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/17.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"
@class CLLotteryPeriodModel, CLLotteryActivitiesModel;
@interface CLLotteryBetDetailPeriodModel : CLBaseModel

@property (nonatomic, strong) CLLotteryPeriodModel *currentPeriod;
@property (nonatomic, strong) NSString *subPeriod;
@property (nonatomic, strong) CLLotteryActivitiesModel *activityMap;

@end
