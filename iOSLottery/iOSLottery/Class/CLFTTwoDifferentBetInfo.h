//
//  CLFTTwoDifferentBetInfo.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/23.
//  Copyright © 2016年 caiqr. All rights reserved.
//
//二不同号
#import "CLLotteryBaseBetTerm.h"
@interface CLFTTwoDifferentBetInfo : CLLotteryBaseBetTerm

@property (nonatomic, strong) NSMutableArray *twoDifferentBetArray;
//奖金
@property (nonatomic, assign) double bonus;
@end
