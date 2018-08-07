//
//  CLPreTwoDirectBetManager.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/6.
//  Copyright © 2016年 caiqr. All rights reserved.
//前二直选 投注逻辑 处理 （拆单）

#import <Foundation/Foundation.h>
@class CLDETwoGroupBetTerm;
@class CLDEBonusInfo;
@interface CLPreTwoDirectBetManager : NSObject

@property (nonatomic, strong) NSMutableArray *firstBetTermArray; //第一组 投注项
@property (nonatomic, strong) NSMutableArray *secondBetTermArray;//第二组 投注项
@property (nonatomic, strong) CLDEBonusInfo *bonusInfo;

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
 投注项的数组
 */
@property (nonatomic, strong, readonly) NSArray <CLDETwoGroupBetTerm *> *betTermArray;

@end
