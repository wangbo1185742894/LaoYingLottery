//
//  SLAwardAmountRequset.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/7/25.
//  Copyright © 2017年 caiqr. All rights reserved.
//  计算预计奖金接口

#import "CLLotteryBusinessRequest.h"

@interface SLAwardAmountRequset : CLLotteryBusinessRequest<CLBaseConfigRequest>

/**
 请求参数
 */
@property (nonatomic, strong) NSString *lotteryNumber;

/**
 投注倍数
 */
@property (nonatomic, strong) NSString *betTimes;

@end
