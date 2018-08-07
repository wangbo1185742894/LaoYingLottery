//
//  SLAwardAmountRequset.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/7/25.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLAwardAmountRequset.h"

@implementation SLAwardAmountRequset

- (NSString *)requestBaseUrlSuffix{
    
    return @"/bet/bonus/range";
}

- (NSDictionary *)requestBaseParams
{

    return @{@"lotteryNumber" : self.lotteryNumber,@"betTimes" : self.betTimes};

}

- (NSTimeInterval)requestTimeoutInterval
{
    return 0.5;
}

@end
