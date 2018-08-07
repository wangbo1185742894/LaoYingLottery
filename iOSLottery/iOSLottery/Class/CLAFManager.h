//
//  CLAFManager.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/26.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *pl5ShakeNotification = @"pl5ShakeNotification";

@interface CLAFManager : NSObject

+ (instancetype)shareManager;

- (void)setLotteryGame:(NSString *)str;

/**
 设置中奖数据
 */
- (void)setBonusMessageWithData:(NSArray *)data;

/**
 获取当前玩法对应的中奖信息
 */
- (NSString *)getCurrentBounsMessage;

//设置遗漏信息
- (void)setOmissionMessageWithData:(NSDictionary *)dic;

//获取当前玩法对应的遗漏信息
- (NSArray *)getOmissionMessageOfCurrentPlayMethod;

/**
 保存一个选项
 */
- (void)saveOneOptions:(NSString *)options withGroupTag:(NSString *)groupTag;

/**
 保存一组投注项
 */
- (void)saveOneGroupBetOptionsOfReplaceIndex:(NSInteger)index;

- (void)saveOneGroupOptions:(NSArray *)array;

/**
 删除一个选项
 */
- (void)removeOneOptions:(NSString *)options withGroupTag:(NSString *)groupTag;

/**
 当前玩法是否有选中项
 */
- (BOOL)hasSelectedOptionsOfCurrentPlayMethod;

/**
 获取当前玩法投注注数
 */
- (NSInteger)getNoteNumber;


/**
 获取随机号
 */
- (NSArray *)getRandomNumber;


- (NSArray *)getCurrentPlayMethodSelectedOptions;

- (void)randomAddOneBetOptions;


/**
 获取提示文字
 */
- (NSString *)getToastText;

/**
 清空选项
 */
- (void)clearOptions;

@end
