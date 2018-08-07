//
//  CLFTThreeDifferentAllBetInfo.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/23.
//  Copyright © 2016年 caiqr. All rights reserved.
//
//三连号通选
#import "CLLotteryBaseBetTerm.h"
@interface CLFTThreeDifferentAllBetInfo : CLLotteryBaseBetTerm

@property (nonatomic, strong) NSMutableArray *threeDifferentAllArray;
//奖金
@property (nonatomic, assign) NSInteger bonus;
@end
