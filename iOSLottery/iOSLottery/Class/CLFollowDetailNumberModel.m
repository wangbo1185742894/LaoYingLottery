//
//  CLFollowDetailNumberModel.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/22.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFollowDetailNumberModel.h"

@implementation CLFollowDetailNumberModel

- (void)setLotteryNumber:(NSString *)lotteryNumber {
    if ([lotteryNumber rangeOfString:@":"].length > 0) {
        _lotteryNumber = [lotteryNumber stringByReplacingOccurrencesOfString:@":" withString:@" | "];
    } else {
        _lotteryNumber = lotteryNumber;
    }
}

@end
