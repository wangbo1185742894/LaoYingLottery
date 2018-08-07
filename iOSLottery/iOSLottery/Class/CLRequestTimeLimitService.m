//
//  CLRequestTimeLimitService.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/20.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLRequestTimeLimitService.h"
#import "CLConfigMessage.h"
@interface CLRequestTimeLimitService ()

@property (nonatomic, assign) NSInteger requestTime;//请求时间限制
@property (nonatomic, assign) NSInteger totalCountLimit;//请求总次数限制(暂无)

@end

@implementation CLRequestTimeLimitService
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestTime = 0;
        self.maxRequestTimeLimit = 20;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeAdd:) name:GlobalTimerRuning object:nil];
    }
    return self;
}

- (void)timeAdd:(NSNotification *)nofiti{
    
    self.requestTime++;
}

- (BOOL)requestTimeLimit{
    
    
    if (self.requestTime > self.maxRequestTimeLimit || self.requestTime == 0) {
        //保证接口第一次请求正确
        self.requestTime = 1;
        return YES;
    }else{
        return NO;
    }
}

@end
