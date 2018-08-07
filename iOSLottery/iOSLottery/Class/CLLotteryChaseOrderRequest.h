//
//  CLLotteryChaseOrderRequest.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/20.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLLotteryBusinessRequest.h"

@interface CLLotteryChaseOrderRequest : CLLotteryBusinessRequest<CLBaseConfigRequest>

@property (nonatomic, strong) NSString *gameId;//彩种
@property (nonatomic, strong) NSString *lotteryNumber;//投注号
@property (nonatomic, strong) NSString *amount;//金额
@property (nonatomic, strong) NSString *followMode;//中奖后是否停止  1表示停止
@property (nonatomic, strong) NSString *totalPeriod;//追号总期次
@property (nonatomic, strong) NSString *periodTimesStr;//追号期次_倍数
@property (nonatomic, strong) NSString *followType;//追号类型 普通追号 智能追号
@property (nonatomic, strong) NSString *gameExtra;//是否追加

@end
