//
//  CLLotteryBetRequest.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/17.
//  Copyright © 2017年 caiqr. All rights reserved.
//
//投注页面的 请求接口

#import "CLLotteryBusinessRequest.h"

@interface CLLotteryBetRequest : CLLotteryBusinessRequest<CLBaseConfigRequest>

@property (nonatomic, strong) NSString *gameEn;

@end
