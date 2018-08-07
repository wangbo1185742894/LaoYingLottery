//
//  CLJumpLotteryManager.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/22.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CLJumpLotteryManager : NSObject


/**
 //跳转彩种 默认校验是否有缓存

 @param lotteryGameEn gameEn
 */
+ (void)jumpLotteryWithGameEn:(NSString *)lotteryGameEn;


/**
 跳转彩种

 @param lotteryGameEn gameEn
 @param isJudgeCache 校验缓存
 */
+ (void)jumpLotteryWithGameEn:(NSString *)lotteryGameEn isJudgeCache:(BOOL)isJudgeCache;


/**
 跳转彩种后销毁当前页 默认不校验是否有投注缓存

 @param lotteryGameEn gameEn
 */
+ (void)jumpLotteryDestoryWithGameEn:(NSString *)lotteryGameEn;

/**
 跳转彩种

 @param lotteryGameEn gameEn
 @param isJudgeCache 是否校验缓存
 */
+ (void)jumpLotteryDestoryWithGameEn:(NSString *)lotteryGameEn isJudgeCache:(BOOL)isJudgeCache;


/**
 跳转彩种对应玩法

 @param lotteryGameEn gameEn
 @param playMothed 玩法
 */
+ (void)jumpLotteryWithGameEn:(NSString *)lotteryGameEn playMothed:(NSString *)playMothed;

@end
