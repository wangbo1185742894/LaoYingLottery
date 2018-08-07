//
//  CLLotteryBonusInfoRequest.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/19.
//  Copyright © 2016年 caiqr. All rights reserved.
//
//指定期次的开奖接口

#import "CLLotteryBusinessRequest.h"

@interface CLLotteryBonusInfoRequest : CLLotteryBusinessRequest

@property (nonatomic, strong) NSString *periodId;
@property (nonatomic, strong) NSString *gameEn;

@end
