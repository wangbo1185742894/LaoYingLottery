//
//  SLBetDetailDataManager.h
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/22.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLBetDetailDataManager : NSObject

///**
// 是否在投注详情控制器用到该类
// */
//@property (nonatomic, assign) BOOL inBetDetailsVC;

/**
 获取投注信息数组

 @return 投注数组
 */
+ (NSArray *)getBetInfo;


/**
 获取可选串关

 @return 串关
 */
+ (NSArray *)getChuanGuan;

/**
 获取注数

 @return 注数
 */
+ (NSInteger)getNote;

/**
 获取倍数

 @return 倍数
 */
+ (NSInteger)getMultiple;


/**
 预计奖金

 @return 预计奖金字符串
 */
+ (NSString *)getExpectedBonus;

/**
 获取所有选项赔率字符串(用于请求接口)
 */
+ (NSString *)getAllOddsString;

/**
 是否显示toast
 */
+ (BOOL)isShowToast;

+ (void)setInBetDetailsVC:(BOOL)inBetDetailsVC;

+ (BOOL)inBetDetailsVC;

@end

