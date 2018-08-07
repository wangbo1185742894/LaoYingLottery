//
//  CLAwardNoticeAPI.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLLotteryBusinessRequest.h"

@interface CLAwardNoticeAPI : CLLotteryBusinessRequest

- (void)deallingWithData:(NSArray*)array;

- (NSArray*)pullData;

@end
