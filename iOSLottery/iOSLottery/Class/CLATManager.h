//
//  CLATManager.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/14.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const playMethodTpyeOne;

UIKIT_EXTERN NSString *const playMethodTpyeTwo;

UIKIT_EXTERN NSString *const playMethodTpyeThree;

UIKIT_EXTERN NSString *const playMethodTpyeFour;

static NSString *pl3ShakeNotification = @"pl3ShakeNotification";

typedef NS_ENUM(NSUInteger, CLATPlayMethodType) {
    
    CLATPlayMothedTypeOne = 0, //直选
    CLATPlayMothedTypeTwo, //组三单式
    CLATPlayMothedTypeThree, //组三复式
    CLATPlayMothedTypeFour //组六
};

@interface CLATManager : NSObject

+ (instancetype)shareManager;

- (void)setLotteryGame:(NSString *)str;

/**
 设置当前玩法
 */
- (void)setCurrentPlayMethod:(CLATPlayMethodType)playMethod;

/**
 获取当前玩法
 */
- (CLATPlayMethodType)getCurrentPlayMethodType;

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
 获取当前玩法的选中项
 */
- (NSMutableArray *)getCurrentPlayMethodSelectedOptions;

/**
 获取当前玩法投注注数
 */
- (NSInteger)getNoteNumber;

/**
 保存一组投注项
 */
- (void)saveOneGroupBetOptionsOfReplaceIndex:(NSInteger)index;

//获取提示文字
- (NSString *)getToastText;

/**
 获取随机号
 */
- (NSArray *)getRandomNumber;

/**
 随机添加一组投注项
 */
- (void)randomAddOneBetOptions;

/**
 清空当前玩法选项
 */
- (void)clearCurrentPlayMethodSelectedOptions;

/**
 清空选项
 */
- (void)clearOptions;


@end
