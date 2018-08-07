//
//  CLLotteryDataManager.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/4/12.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLLotteryMainBetModel;
@class CLLotteryBonusNumModel;
@class CLLotteryPeriodModel;
@class CLLotteryActivitiesModel;
@class CLFTBonusInfo;
@class CLDEBonusInfo;
@interface CLLotteryDataManager : NSObject

#pragma mark - 存数据
/**
 存所有数据

 @param data data
 @param gameEn gameEn
 */
+ (void)storeAllInfoData:(id)data gameEn:(NSString *)gameEn;

/**
 存上一期开奖信息

 @param lastBonus lastBonus
 @param gameEn gameEn
 */
+ (void)storeLastPeriodBonusData:(CLLotteryBonusNumModel *)lastBonus gameEn:(NSString *)gameEn;

/**
 存当前期的期次信息

 @param currentPeriod currentPeriod
 @param subPeriod subPeriod
 @param gameEn gameEn
 */
+ (void)storeCurrentPeriod:(CLLotteryPeriodModel *)currentPeriod currentSubPeriod:(NSString *)subPeriod gameEn:(NSString *)gameEn;


#pragma mark - 取数据

/**
 取投注页面所有数据

 @param gameEn gameEn
 @return 所有数据
 */
+ (CLLotteryMainBetModel *)getAllInfoDataGameEn:(NSString *)gameEn;

/**
 取 上一期的开奖信息

 @param gameEn gameEn
 @return 上一期开奖信息
 */
+ (CLLotteryBonusNumModel *)getLastPeriodBonusDataGameEn:(NSString *)gameEn;

/**
 取 开奖列表

 @param gameEn gameEn
 @return 开奖列表
 */
+ (NSArray <CLLotteryBonusNumModel *> *)getRecentBonusDataGameEn:(NSString *)gameEn;

/**
 取 当前期次信息

 @param gameEn gameEn
 @return 当前期次信息
 */
+ (CLLotteryPeriodModel *)getCurrentPeriodInfoDataGameEn:(NSString *)gameEn;

/**
 取遗漏

 @param gameEn gameEn
 @return 遗漏
 */
+ (NSDictionary *)getOmissionDataGameEn:(NSString *)gameEn;

/**
 取活动链接

 @param gameEn gameEn
 @return 活动链接
 */
+ (CLLotteryActivitiesModel *)getActivityLink:(NSString *)gameEn;


/**
 获取奖级信息

 @param gameEn gameEn
 @return 奖级信息
 */
+ (NSDictionary *)getBonusInfoWithGameEn:(NSString *)gameEn;


/**
 加奖标记

 @param gameEn gameEn
 @return 加奖
 */
+ (NSArray *)getAddBonusGameEn:(NSString *)gameEn;


/**
 中奖奖金说明

 @param gameEn gameEn
 @return 奖金说明
 */
+ (NSArray *)getShowBonusInfoGameEn:(NSString *)gameEn;
@end
