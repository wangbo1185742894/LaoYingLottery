//
//  CLContinueToPayAPI.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/26.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLLotteryBusinessRequest.h"

@interface CLContinueToPayAPI : CLLotteryBusinessRequest

@property (nonatomic, strong) NSString* followId;
@property (nonatomic, strong) NSString* orderId;

@end
