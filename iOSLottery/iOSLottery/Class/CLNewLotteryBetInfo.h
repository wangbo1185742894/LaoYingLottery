//
//  CLNewLotteryBetInfo.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/22.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLNewLotteryBetInfo : NSObject

/**
 单例
 
 @return 单例
 */
+ (CLNewLotteryBetInfo *)shareLotteryBetInfo;

/**
 返回投注订单串
 
 @return 投注订单串
 */
- (NSString *)getOrderBetNumberWithLottery:(NSString *)lotteryGameEn;

/**
 添加一条投注信息
 
 @param betTermInfo 投注项信息
 */
- (void)addLotteryBetTerm:(NSArray *)betTermInfo lotteryType:(NSString *)lotteryGameEn;

/**
 替换一条投注数据
 
 @param betTermInfo 投注的数据
 @param lotteryGameEn 彩种
 @param index 替换位置
 */
- (void)replaceLotteryBetTerm:(NSArray *)betTermInfo lotteryType:(NSString *)lotteryGameEn index:(NSInteger)index;

/**
 获取对应彩种的投注项
 
 @param lotteryGameEn 彩种类型
 
 @return 彩种的投注项 数组
 */
- (NSArray *)getBetTermsWithLotteryType:(NSString *)lotteryGameEn;

/**
 获取彩种的注数
 
 @param lotteryGameEn 彩种类型
 
 @return 返回注数
 */
- (NSInteger)getAllNoteWithLottery:(NSString *)lotteryGameEn;


/**
 设置彩种的追期
 
 @param period      追期
 @param lotteryGameEn 彩种
 */
- (void)setPeriod:(NSInteger)period lottery:(NSString *)lotteryGameEn;


/**
 设置彩种的倍数
 
 @param multiple    倍数
 @param lotteryGameEn 彩种
 */
- (void)setMultiple:(NSInteger)multiple lottery:(NSString *)lotteryGameEn;
#pragma mark - 设置彩种gameEn
- (void)setGameEn:(NSString *)gameEn lottery:(NSString *)lotteryGameEn;
#pragma mark - 设置彩种gameId
- (void)setGameId:(NSString *)gameId lottery:(NSString *)lotteryGameEn;
#pragma mark - 设置彩种periodId
- (void)setPeriodId:(NSString *)periodId lottery:(NSString *)lotteryGameEn;
#pragma mark - 设置彩种followMode
- (void)setFollowMode:(NSString *)followMode lottery:(NSString *)lotteryGameEn;
#pragma mark - 设置彩种followTpye
- (void)setFollowType:(NSString *)followType lottery:(NSString *)lotteryGameEn;

#pragma mark - 获取彩种gameEn
- (NSString *)getGameEnWithLottery:(NSString *)lotteryGameEn;
#pragma mark - 获取彩种gameId
- (NSString *)getGameIdWithLottery:(NSString *)lotteryGameEn;
#pragma mark - 获取彩种periodId
- (NSString *)getPeriodIdWithLottery:(NSString *)lotteryGameEn;
#pragma mark - 获取彩种followMode
- (NSString *)getFollowModeWithLottery:(NSString *)lotteryGameEn;
#pragma mark - 获取彩种followTpye
- (NSString *)getFollowTypeWithLottery:(NSString *)lotteryGameEn;
/**
 获取追期
 
 @param lotteryGameEn 彩种
 
 @return 期次
 */
- (NSInteger)getPeriodWithLottery:(NSString *)lotteryGameEn;

/**
 获取倍数
 
 @param lotteryGameEn 彩种
 
 @return 倍数
 */
- (NSInteger)getMultipleWithLottery:(NSString *)lotteryGameEn;

/**
 删除一条数据
 
 @param index       删除位置
 @param lotteryGameEn 删除类型
 
 */
- (void)deleteOneBetInfoWithIndex:(NSInteger)index lottery:(NSString *)lotteryGameEn;

/**
 删除所有数据
 
 @param lotteryGameEn 彩种
 */
- (void)deleteAllBetInfoWithLottery:(NSString *)lotteryGameEn;

/**
 获取某一条投注信息
 
 @param index       位置
 @param lotteryGameEn 彩种
 
 @return 返回投注信息
 */
- (id)getBetInfoWithIndex:(NSInteger)index lottery:(NSString *)lotteryGameEn;


/**
 获取玩法
 
 @param index       投注信息的位置
 @param lotteryGameEn 彩种
 
 @return 返回玩法
 */
- (NSInteger)getPlayMothedTypeWithIndex:(NSInteger)index lottery:(NSString *)lotteryGameEn;


/**
 随机添加一注
 
 @param lotteryGameEn 彩种
 */
- (void)randomAddOneBetInfoWithLottery:(NSString *)lotteryGameEn;


/**
 设置追加

 @param isAdd 追加
 @param lotteryGameEn gameEn
 */
- (void) setIsAdditional:(BOOL)isAdd lottery:(NSString *)lotteryGameEn;

/**
 返回是否追加

 @param lotteryGameEn gameEn
 @return 是否追加
 */
- (BOOL)getIsAdditionalWithLottery:(NSString *)lotteryGameEn;
@end
