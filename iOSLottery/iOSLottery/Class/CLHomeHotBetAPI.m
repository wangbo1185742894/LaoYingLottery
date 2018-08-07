//
//  CLHomeHotBetAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/8.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLHomeHotBetAPI.h"
#import "CLRequestTimeLimitService.h"

@interface CLHomeHotBetAPI () <CLBaseConfigRequest>
@property (nonatomic, strong) CLRequestTimeLimitService *timeLimit;//时间限制
@end

@implementation CLHomeHotBetAPI

- (void)start{
    
    if ([self.timeLimit requestTimeLimit]) {
        [super start];
    }else{
        return;
    }
}

- (NSString *)methodName {
    
    return @"/index/hot";
}

- (NSString *)requestBaseUrlSuffix {
    
    return @"/index/hot";
}
#pragma mark ------------ getter Mothed ------------
- (CLRequestTimeLimitService *)timeLimit{
    
    if (!_timeLimit) {
        _timeLimit = [[CLRequestTimeLimitService alloc] init];
    }
    return _timeLimit;
}
@end
