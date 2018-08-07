//
//  CLSFCManager.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/26.
//  Copyright © 2017年 caiqr. All rights reserved.
//  胜负彩单例管理者

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CLSFCPlayMethod){

    CLSFCPlayMethodNormal = 0,
    CLSFCPlayMethodRx9
    
};

@class CLSFCSelectedModel;

@interface CLSFCManager : NSObject

+ (instancetype)shareManager;

/**
 处理网络数据
 */
- (void)disposeData:(id)data;

/**
 设置当前彩种玩法
 */
- (void)setCurrentPlayMethodWithLotteryName:(NSString *)lotteryName;

- (NSArray *)getListData;

/**
 获取期次id
 */
- (NSString *)getPeriodId;

/**
 获取玩法id
 */
- (NSString *)getGameId;

/**
 获取投注串
 */
- (NSString *)getLotteryNumber;


- (void)setBetTimes:(NSInteger)times;
/**
 获取投注倍数
*/
- (NSInteger)getBetTimes;

- (NSInteger)getMaxBetTimes;

- (NSInteger)getDefaultBetTims;

//期次截止时间
- (long)getPeriodTime;

- (NSInteger)getIfCountDown;

/**
 保存一个投注项
 */
- (void)saveOneOption:(NSString *)options matchId:(NSString *)matchId;

/**
 删除一个投注项
 */
- (void)removeOneOptions:(NSString *)options matchId:(NSString *)matchId;

/**
 获取选中模型
 */
- (CLSFCSelectedModel *)getSelectedModelWithMatchId:(NSString *)matchId;

/**
 获取当前玩法注数
 */
- (NSInteger)getNoteNumber;

/**
 获取当前选中项个数
 */
- (NSInteger)getSelectOptionsCount;

/**
 获取至少选项个数
 */
- (NSInteger)getMinSelectOptionsCount;

- (NSInteger)getDefaultMultiple;

/**
 获取提示信息
 */
- (NSString *)getToastText;

/**
 清空选项
 */
- (void)clearOptions;

@end
