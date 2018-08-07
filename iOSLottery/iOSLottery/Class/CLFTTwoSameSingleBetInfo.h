//
//  CLFTTwoSameSingleBetInfo.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/23.
//  Copyright © 2016年 caiqr. All rights reserved.
//
//二同号单选
#import "CLLotteryBaseBetTerm.h"
@interface CLFTTwoSameSingleBetInfo : CLLotteryBaseBetTerm

//投注项数组
@property (nonatomic, strong) NSMutableArray *sameNumberBetArray;//同号 数组
@property (nonatomic, strong) NSMutableArray *singleBetArray;//单号 数组
//奖金
@property (nonatomic, assign) NSInteger bonus;
@end
