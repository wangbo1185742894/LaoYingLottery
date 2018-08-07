//
//  CLDEDTBetTerm.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/6.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLLotteryBaseBetTerm.h"
@class CLDEBonusInfo;
@interface CLDEDTBetTerm : CLLotteryBaseBetTerm

@property (nonatomic, strong) NSMutableArray *danBetTermArray; //胆码组 投注项
@property (nonatomic, strong) NSMutableArray *tuoBetTermArray;//拖码组 投注项
@property (nonatomic, strong) CLDEBonusInfo *bonusInfo;
@end
