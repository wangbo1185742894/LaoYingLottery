//
//  CLFTHeZhiBetInfo.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/19.
//  Copyright © 2016年 caiqr. All rights reserved.
//
//和值 投注 项
#import "CLLotteryBaseBetTerm.h"
@interface CLFTHeZhiBetInfo : CLLotteryBaseBetTerm

//投注项数组
@property (nonatomic, strong) NSMutableArray *heZhiBetArray;
@property (nonatomic, strong) NSMutableArray *bonusArray;//奖金

@end
