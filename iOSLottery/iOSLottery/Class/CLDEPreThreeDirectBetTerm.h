//
//  CLDEPreThreeDirectBetTerm.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/6.
//  Copyright © 2016年 caiqr. All rights reserved.
// 前三直选投注项

#import "CLLotteryBaseBetTerm.h"
@class CLDEBonusInfo;

@interface CLDEPreThreeDirectBetTerm : CLLotteryBaseBetTerm

@property (nonatomic, strong) NSMutableArray *firstBetTermArray; //第一组 投注项
@property (nonatomic, strong) NSMutableArray *secondBetTermArray;//第二组 投注项
@property (nonatomic, strong) NSMutableArray *thirdBetTermArray;//第三组 投注项
@property (nonatomic, strong) CLDEBonusInfo *bonusInfo;

@end
