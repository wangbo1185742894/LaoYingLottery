//
//  CLLotteryBaseBetTermInfo.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/22.
//  Copyright © 2016年 caiqr. All rights reserved.
//所有彩种投注项的基类

#import <Foundation/Foundation.h>

@interface CLLotteryBaseBetTermInfo : NSObject

@property (nonatomic, assign) NSInteger period;//追期
@property (nonatomic, assign) NSInteger multiple;//倍数
@property (nonatomic, strong) NSString *periodId;//当前期次
@property (nonatomic, strong) NSString *gameEn;//彩种名
@property (nonatomic, strong) NSString *gameId;//彩种id
@property (nonatomic, strong) NSString *followMode;//中奖后是否停止追号
@property (nonatomic, strong) NSString *followType;//普通追号  智能追号
@property (nonatomic, assign) BOOL isAdditional;//是否追加
/**
 返回投注订单串
 
 @return 投注订单串
 */
- (NSString *)getOrderBetNumber;

/**
 添加一条投注信息
 
 @param betTermInfo 投注项信息
 */
- (void)addLotteryBetTerm:(NSArray *)betTermInfo;

/**
 替换一条投注数据
 
 @param betTermInfo 投注的数据
 @param index 替换位置
 */
- (void)replaceLotteryBetTerm:(NSArray *)betTermInfo index:(NSInteger)index;

/**
 获取对应彩种的投注项
 
 @return 彩种的投注项 数组
 */
- (NSArray *)getBetTerms;

/**
 获取彩种的注数
 
 @return 返回注数
 */
- (NSInteger)getAllNote;


/**
 删除一条数据
 
 @param index       删除位置
 
 */
- (void)deleteOneBetInfoWithIndex:(NSInteger)index;

/**
 删除所有数据
 
 */
- (void)deleteAllBetInfo;

/**
 获取某一条投注信息
 
 @param index       位置
 
 @return 返回投注信息
 */
- (id)getBetInfoWithIndex:(NSInteger)index;


/**
 获取玩法
 
 @param index       投注信息的位置
 
 @return 返回玩法
 */
- (NSInteger)getPlayMothedTypeWithIndex:(NSInteger)index;

/**
 随机添加一注
 */
- (void)randomAddOneBetInfo;

@end
