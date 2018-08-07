//
//  CLFTThreeSameAllBetInfo.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/22.
//  Copyright © 2016年 caiqr. All rights reserved.
//
//三同号 通选 投注项
#import "CLLotteryBaseBetTerm.h"
@interface CLFTThreeSameAllBetInfo : CLLotteryBaseBetTerm

//投注项数组
@property (nonatomic, strong) NSMutableArray *threeSameAllBetArray;
//奖金
@property (nonatomic, assign) NSInteger bonus;
@end
