//
//  CLLotteryPeriodRequest.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/17.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLLotteryPeriodRequest.h"
#import "CLRequestTimeLimitService.h"
@interface CLLotteryPeriodRequest ()

@property (nonatomic, strong) CLRequestTimeLimitService *timeLimit;//时间限制

@end
@implementation CLLotteryPeriodRequest

- (void)start{
    
    if ([self.timeLimit requestTimeLimit]) {
        [super start];
    }else{
        return;
    }
}

- (instancetype) init {
    
    self = [super init];
    if (self ) {
        
    }
    return self;
}
- (NSTimeInterval)requestTimeoutInterval {
    
    return 7.f;
}

- (NSString *)requestBaseUrlSuffix {
    
    return [NSString stringWithFormat:@"/bet/period/%@",self.gameEn];;
}
#pragma mark ------------ getter Mothed ------------
- (CLRequestTimeLimitService *)timeLimit{
    
    if (!_timeLimit) {
        _timeLimit = [[CLRequestTimeLimitService alloc] init];
        _timeLimit.maxRequestTimeLimit = 5.f;
    }
    return _timeLimit;
}
@end
