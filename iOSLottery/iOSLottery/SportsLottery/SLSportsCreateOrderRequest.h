//
//  SLSportsCreateOrderRequest.h
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/26.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLLotteryBusinessRequest.h"

@interface SLSportsCreateOrderRequest : CLLotteryBusinessRequest<CLBaseConfigRequest>

@property (nonatomic, strong) NSString *gameId;//彩种
@property (nonatomic, strong) NSString *betTimes;//投注倍数
@property (nonatomic, strong) NSString *lotteryNumber;//投注号
@property (nonatomic, strong) NSString *amount;//金额
@property (nonatomic, strong) NSString *gameExtra;//串关数

@end
