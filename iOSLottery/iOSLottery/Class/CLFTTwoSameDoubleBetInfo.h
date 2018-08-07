//
//  CLFTTwoSameDoubleBetInfo.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/23.
//  Copyright © 2016年 caiqr. All rights reserved.
//
//二同号 复选
#import "CLLotteryBaseBetTerm.h"
@interface CLFTTwoSameDoubleBetInfo : CLLotteryBaseBetTerm
//投注项数组
@property (nonatomic, strong) NSMutableArray *twoSameDoubleBetArray;
//奖金
@property (nonatomic, assign) NSInteger bonus;
@end
