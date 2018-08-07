//
//  SLOrderContinuePayRequest.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/6/19.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLLotteryBusinessRequest.h"

@interface SLOrderContinuePayRequest : CLLotteryBusinessRequest<CLBaseConfigRequest>

@property (nonatomic, strong) NSString* orderId;

@end
