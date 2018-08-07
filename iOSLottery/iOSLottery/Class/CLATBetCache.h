//
//  CLATBetCache.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/23.
//  Copyright © 2017年 caiqr. All rights reserved.
//  排列3 排列5 福彩3D 缓存

#import <Foundation/Foundation.h>

@class CLDEBetDetailModel;

@interface CLATBetCache : NSObject

+ (instancetype)shareCache;

/**
 获取指定彩种投注期次
 */
- (NSInteger)getPeriodWithLotteryName:(NSString *)lottery;

/**
 保存保存指定彩种投注期次
 */
- (void)setPeriod:(NSInteger)period ofLotteryName:(NSString *)lottery;

/**
 获取指定彩种投注倍数
 */
- (NSInteger)getTimesWithLotteryName:(NSString *)lottery;

/**
 保存保存指定彩种投注倍数
 */
- (void)setTimes:(NSInteger)times ofLotteryName:(NSString *)lottery;

/**
 获取指定彩种投注总注数
 */
- (NSInteger)getNoteNumberWithLotteryName:(NSString *)lottery;

/**
 获取指定彩种，投注串
 */
- (NSString *)getLotteryNumberWithLotteryName:(NSString *)lotteryName;

//保存彩种当前的玩法
- (void)saveCurrentLottery:(NSString *)lotteryName ofPlayMethod:(NSInteger)playMethod;

//获取彩种当前的玩法
- (NSInteger)getPlayMethodOfCurrentLottery:(NSString *)lotteryName;


/**
 保存一组投注项
 */
- (void)saveOneGroupBetOptions:(CLDEBetDetailModel *)options ofLotteryName:(NSString *)lotteryName;

/**
 替换一组投注项
 */
- (void)replaecOneGroupBetOptions:(CLDEBetDetailModel *)options ofLotteryName:(NSString *)lotteryName atIndex:(NSInteger)index;

/**
 删除一组投注项
 */
- (void)removeOneGroupBetOptionsWithIndex:(NSInteger)index ofLotteryName:(NSString *)lotteryName;


//获取彩种的全部投注项
- (NSMutableArray *)getBetOptionsCacheWithLotteryName:(NSString *)lotteryName;

/**
 保存彩种的所有投注项
 */
- (void)saveBetOptionsCacheWithLotteryName:(NSString *)lotteryName data:(NSMutableArray *)data;

/**
 删除指定保存的投注内容
 */
- (void)deleteBetOptionsCacheWithLotteryName:(NSString *)lotteryName;

//
- (id)getBetModelWithIndex:(NSInteger)index lottery:(NSString *)lotteryGameEn;

@end
