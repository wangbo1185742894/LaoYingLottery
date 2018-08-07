//
//  CLDETwoGroupBetTerm.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/6.
//  Copyright © 2016年 caiqr. All rights reserved.
//前二直选的投注项

#import "CLLotteryBaseBetTerm.h"
@class CLDEBonusInfo;
@interface CLDETwoGroupBetTerm : CLLotteryBaseBetTerm

@property (nonatomic, strong) NSMutableArray *firstBetTermArray; //第一组 投注项
@property (nonatomic, strong) NSMutableArray *secondBetTermArray;//第二组 投注项

@property (nonatomic, strong) CLDEBonusInfo *bonusInfo;
@end
