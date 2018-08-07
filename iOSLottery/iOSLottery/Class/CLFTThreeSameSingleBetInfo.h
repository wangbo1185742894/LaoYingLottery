//
//  CLFTThreeSameSingleBetInfo.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/22.
//  Copyright © 2016年 caiqr. All rights reserved.
//
//三同号 单选 投注项
#import "CLLotteryBaseBetTerm.h"
@interface CLFTThreeSameSingleBetInfo : CLLotteryBaseBetTerm

//投注项数组
@property (nonatomic, strong) NSMutableArray *threeSameSingleBetArray;

@property (nonatomic, assign) NSInteger bonus;//奖金
@end
