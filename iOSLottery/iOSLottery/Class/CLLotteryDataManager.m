//
//  CLLotteryDataManager.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/4/12.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLLotteryDataManager.h"
#import "CLLotteryAllInfo.h"
#import "CLLotteryMainBetModel.h"
#import "CLLotteryBonusNumModel.h"
@implementation CLLotteryDataManager

#pragma mark ------------ 存数据 ------------
#pragma mark - 缓存所有数据
+ (void)storeAllInfoData:(id)data gameEn:(NSString *)gameEn{
    
    //存缓存
    [[CLLotteryAllInfo shareLotteryAllInfo] setMainRequestData:[CLLotteryMainBetModel mj_objectWithKeyValues:data] gameEn:gameEn];
}
#pragma mark - 存上一期信息
+ (void)storeLastPeriodBonusData:(CLLotteryBonusNumModel *)lastBonus gameEn:(NSString *)gameEn{
    
    [[CLLotteryAllInfo shareLotteryAllInfo] getMainRequestDataWithGameEn:gameEn].lastAwardInfo = lastBonus;
    NSMutableArray *infoAward = [NSMutableArray arrayWithArray:[[CLLotteryAllInfo shareLotteryAllInfo] getMainRequestDataWithGameEn:gameEn].awardInfoVos];
    for (NSInteger i = 0; i < infoAward.count; i++) {
        
        CLLotteryBonusNumModel *storeBonusModel = infoAward[i];
        if ([storeBonusModel.periodId isEqualToString:lastBonus.periodId]) {
            [infoAward replaceObjectAtIndex:i withObject:lastBonus];
            [[CLLotteryAllInfo shareLotteryAllInfo] getMainRequestDataWithGameEn:gameEn].awardInfoVos = infoAward;
            return;
        }
    }
    [infoAward addObject:lastBonus];
    [[CLLotteryAllInfo shareLotteryAllInfo] getMainRequestDataWithGameEn:gameEn].awardInfoVos = infoAward;
    [[CLLotteryAllInfo shareLotteryAllInfo] getMainRequestDataWithGameEn:gameEn].lastAwardInfo = lastBonus;
}
#pragma mark - 存当前期次信息
+ (void)storeCurrentPeriod:(CLLotteryPeriodModel *)currentPeriod currentSubPeriod:(NSString *)subPeriod gameEn:(NSString *)gameEn{
    
    [[CLLotteryAllInfo shareLotteryAllInfo] getMainRequestDataWithGameEn:gameEn].currentPeriod = currentPeriod;
    [[CLLotteryAllInfo shareLotteryAllInfo] getMainRequestDataWithGameEn:gameEn].currentSubPeriod = subPeriod;
}
#pragma mark ------------ 取数据 ------------
#pragma mark - 获取所有数据
+ (CLLotteryMainBetModel *)getAllInfoDataGameEn:(NSString *)gameEn{
    
    return [[CLLotteryAllInfo shareLotteryAllInfo] getMainRequestDataWithGameEn:gameEn];
}
#pragma mark - 获取上一期次的开奖信息
+ (CLLotteryBonusNumModel *)getLastPeriodBonusDataGameEn:(NSString *)gameEn{
    
    return [[CLLotteryAllInfo shareLotteryAllInfo] getMainRequestDataWithGameEn:gameEn].lastAwardInfo;
}
#pragma mark - 获取近期开奖信息
+ (NSArray <CLLotteryBonusNumModel *> *)getRecentBonusDataGameEn:(NSString *)gameEn{
    
    
    return [[CLLotteryAllInfo shareLotteryAllInfo] getMainRequestDataWithGameEn:gameEn].awardInfoVos;
}
#pragma mark - 获取当前期次的倒计时信息
+ (CLLotteryPeriodModel *)getCurrentPeriodInfoDataGameEn:(NSString *)gameEn{
    
    return [[CLLotteryAllInfo shareLotteryAllInfo] getMainRequestDataWithGameEn:gameEn].currentPeriod;
}
#pragma mark - 获取遗漏
+ (NSDictionary *)getOmissionDataGameEn:(NSString *)gameEn{
    
    return [[CLLotteryAllInfo shareLotteryAllInfo] getMainRequestDataWithGameEn:gameEn].missingNumbers;
}
#pragma mark - 获取活动链接
+ (CLLotteryActivitiesModel *)getActivityLink:(NSString *)gameEn{
    
    return [[CLLotteryAllInfo shareLotteryAllInfo] getMainRequestDataWithGameEn:gameEn].activityMap;
}
#pragma mark - 获取奖级信息
+(NSDictionary *)getBonusInfoWithGameEn:(NSString *)gameEn{
    
    return [[CLLotteryAllInfo shareLotteryAllInfo] getMainRequestDataWithGameEn:gameEn].awardInfoMap;
}
#pragma mark - 加奖标记
+ (NSArray *)getAddBonusGameEn:(NSString *)gameEn{

    return [[CLLotteryAllInfo shareLotteryAllInfo] getMainRequestDataWithGameEn:gameEn].extraBackground;
}
#pragma mark - 展示的中奖信息
+ (NSArray *)getShowBonusInfoGameEn:(NSString *)gameEn{
    
    return [[CLLotteryAllInfo shareLotteryAllInfo] getMainRequestDataWithGameEn:gameEn].awardBonus;
}

@end
