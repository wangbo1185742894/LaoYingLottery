//
//  CLFTThreeDifferentBetInfo.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/23.
//  Copyright © 2016年 caiqr. All rights reserved.
//

//三不同投注
#import "CLLotteryBaseBetTerm.h"
@interface CLFTThreeDifferentBetInfo : CLLotteryBaseBetTerm

@property (nonatomic, strong) NSMutableArray *threeDifferentBetArray;
//奖金
@property (nonatomic, assign) NSInteger bonus;
@end
