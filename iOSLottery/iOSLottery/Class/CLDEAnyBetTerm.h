//
//  CLDEAnyBetTerm.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/5.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLLotteryBaseBetTerm.h"
@class CLDEBonusInfo;
@interface CLDEAnyBetTerm : CLLotteryBaseBetTerm

@property (nonatomic, strong) NSMutableArray <NSString *>*betTermArray;//投注项的数组
@property (nonatomic, strong) CLDEBonusInfo *bonusInfo;

@end
