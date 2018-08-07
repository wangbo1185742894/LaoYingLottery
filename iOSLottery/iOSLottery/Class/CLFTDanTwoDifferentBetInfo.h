//
//  CLFTDanTwoDifferentBetInfo.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/23.
//  Copyright © 2016年 caiqr. All rights reserved.
//
//胆拖二不同号
#import "CLLotteryBaseBetTerm.h"
@interface CLFTDanTwoDifferentBetInfo : CLLotteryBaseBetTerm

@property (nonatomic, strong) NSMutableArray *danTwoDifferentBetArray;
@property (nonatomic, strong) NSMutableArray *tuoTwoDifferentBetArray;
//奖金
@property (nonatomic, assign) NSInteger bonus;
@end
