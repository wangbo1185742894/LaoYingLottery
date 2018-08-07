//
//  CLFTDanThreeDifferentBetInfo.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/23.
//  Copyright © 2016年 caiqr. All rights reserved.
//
//胆拖三不同号
#import "CLLotteryBaseBetTerm.h"
@interface CLFTDanThreeDifferentBetInfo : CLLotteryBaseBetTerm

@property (nonatomic, strong) NSMutableArray *danThreeDifferentBetArray;
@property (nonatomic, strong) NSMutableArray *tuoThreeDifferentBetArray;
//奖金
@property (nonatomic, assign) NSInteger bonus;
@end
