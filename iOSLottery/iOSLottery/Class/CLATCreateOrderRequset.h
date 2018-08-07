//
//  CLATCreateOrderRequset.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/19.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLLotteryBusinessRequest.h"

@interface CLATCreateOrderRequset : CLLotteryBusinessRequest<CLBaseConfigRequest>

/**
 彩种
 */
@property (nonatomic, strong) NSString *gameId;

/**
 期次
 */
@property (nonatomic, strong) NSString *periodId;

/**
 投注倍数
 */
@property (nonatomic, strong) NSString *betTimes;

/**
 投注号
 */
@property (nonatomic, strong) NSString *lotteryNumber;

/**
 金额
 */
@property (nonatomic, strong) NSString *amount;

@end
