//
//  CLDEPreThreeDirectBetManager.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/6.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLDEPreThreeDirectBetTerm;
@class CLDEBonusInfo;
@interface CLDEPreThreeDirectBetManager : NSObject

@property (nonatomic, strong) NSMutableArray *firstBetTermArray; //第一组 投注项
@property (nonatomic, strong) NSMutableArray *secondBetTermArray;//第二组 投注项
@property (nonatomic, strong) NSMutableArray *thirdBetTermArray;//第三组 投注项
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
@property (nonatomic, strong, readonly) NSArray <CLDEPreThreeDirectBetTerm *> *betTermArray;

@end
