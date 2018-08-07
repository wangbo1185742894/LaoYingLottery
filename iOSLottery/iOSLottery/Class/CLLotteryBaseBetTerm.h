//
//  CLLotteryBaseBetTerm.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/10.
//  Copyright © 2016年 caiqr. All rights reserved.
//彩种每一个玩法的投注项基类

#import <Foundation/Foundation.h>
#import "CLDElevenConfigMessage.h"
#import "CLFastThreeConfigMessage.h"
#import "CLTools.h"
#pragma mark ------ 快三 投注类型 枚举 ------
typedef NS_ENUM(NSInteger, CLFTBetType){
    
    CLFTBetTypeHeZhi = 0, //和值
    CLFTBetTypeThreeSameSingle, //三同号单选
    CLFTBetTypeThreeSameAll, //三同号通选
    CLFTBetTypeTwoSameSingle, //二同号单选
    CLFTBetTypeTwoSameDouble, //二同号复选
    CLFTBetTypeThreeDifferent, //三不同号
    CLFTBetTypeThreeDifferentContinuous, //三不同号 三连号通选
    CLFTBetTypeTwoDifferent, //二不同号
    CLFTBetTypeDanTuoThreeDifferent, //胆拖三不同号
    CLFTBetTypeDanTuoTwoDifferent //胆拖二不同号    
};
#pragma mark ------ 和值 创建订单时 对应投注类型 ------
static NSString const * ft_order_heZhi = @"[HEZHI]";//和值
static NSString const * ft_order_sameThreeAll = @"SAME_3_ALL[SAME_3_ALL]";//三同号通选
static NSString const * ft_order_sameThreeSingle = @"[SAME_3_SINGLE]";//三同号单选
static NSString const * ft_order_sameTwoAll = @"[SAME_2_ALL]";//二同号复选
static NSString const * ft_order_sameTwoSingle = @"[SAME_2_SINGLE]";//二同号单选
static NSString const * ft_order_diffThree = @"[DIFF_3]";//三不同号
static NSString const * ft_order_diffTwo = @"[DIFF_2]";//二不同号
static NSString const * ft_order_abcThreeAll = @"ABC_3_ALL[ABC_3_ALL]";//三连号通选

#pragma mark - D11 投注类型名
static NSString *de_order_anyTwo = @"[REN2]";
static NSString *de_order_anyThree = @"[REN3]";
static NSString *de_order_anyFour = @"[REN4]";
static NSString *de_order_anyFive = @"[REN5]";
static NSString *de_order_anySix = @"[REN6]";
static NSString *de_order_anySeven = @"[REN7]";
static NSString *de_order_anyEight = @"[REN8]";
static NSString *de_order_preOne = @"[QIAN_1]";
static NSString *de_order_preTwoDirect = @"[QIAN_2_ZHIXUAN]";
static NSString *de_order_preTwoGroup = @"[QIAN_2_ZUXUAN]";
static NSString *de_order_preThreeDirect = @"[QIAN_3_ZHIXUAN]";
static NSString *de_order_preThreeGroup = @"[QIAN_3_ZUXUAN]";
@interface CLLotteryBaseBetTerm : NSObject

/**
 玩法类型
 */
@property (nonatomic, assign) NSInteger playMothedType;


/**
 快三的投注类型
 */
@property (nonatomic, assign) CLFTBetType betType;

/**
 投注号码（只读）(用于投注详情页展示)
 */
@property (nonatomic, strong, readonly) NSString *betNumber;
/**
 注数（只读）
 */
@property (nonatomic, assign, readonly) NSInteger betNote;

/**
 最小奖金（只读）
 */
@property (nonatomic, assign, readonly) NSInteger minBetBonus;

/**
 最大奖金（只读）
 */
@property (nonatomic, assign, readonly) NSInteger MaxBetBonus;

/**
 创建订单时的投注字符串
 */
@property (nonatomic, strong, readonly) NSString *orderBetNumber;

//添加投注项
- (void)addBetTerm:(NSString *)betTerm;
//删除投注项
- (void)removeBetTerm:(NSString *)betTerm;
@end
