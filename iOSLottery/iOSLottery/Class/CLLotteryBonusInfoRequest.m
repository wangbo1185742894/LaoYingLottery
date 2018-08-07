//
//  CLLotteryBonusInfoRequest.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/19.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLLotteryBonusInfoRequest.h"
#import "CLRequestTimeLimitService.h"
@interface CLLotteryBonusInfoRequest ()<CLBaseConfigRequest>

@property (nonatomic, strong) CLRequestTimeLimitService *timeLimit;//时间限制

@end

@implementation CLLotteryBonusInfoRequest

- (void)start{
    
    if ([self.timeLimit requestTimeLimit]) {
        [super start];
    }else{
        return;
    }
}

- (NSTimeInterval)requestTimeoutInterval {
    
    return 7.f;
}

- (NSString *)requestBaseUrlSuffix {
    
    return [NSString stringWithFormat:@"/bet/%@/%@", self.gameEn, self.periodId];;
}

#pragma mark ------------ getter Mothed ------------
- (CLRequestTimeLimitService *)timeLimit{
    
    if (!_timeLimit) {
        _timeLimit = [[CLRequestTimeLimitService alloc] init];
        _timeLimit.maxRequestTimeLimit = 5;
    }
    return _timeLimit;
}
@end
