//
//  CLHomeAPI.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/8.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLLotteryBusinessRequest.h"

@interface CLHomeAPI : CLLotteryBusinessRequest

- (void) dealingWithHomeData:(NSDictionary*)dict;

- (NSArray*) bannerData;

- (NSArray*) reports;

@end
