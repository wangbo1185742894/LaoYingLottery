//
//  CLBetLimitRequestTool.m
//  iOSLottery
//
//  Created by 洪利 on 2018/6/30.
//  Copyright © 2018年 caiqr. All rights reserved.
//

#import "CLBetLimitRequestTool.h"
#import "CLBetLimitAPI.h"
#import "CQDefinition.h"
#import "CLGlobalTimer.h"
#import "CLConfigMessage.h"
#import "CLTabbarTempCheckAPI.h"
@interface CLBetLimitRequestTool ()<CLRequestCallBackDelegate>

@property (nonatomic, strong) CLBetLimitAPI *betlimitapi;
@property (nonatomic, strong) CLTabbarTempCheckAPI *tabbarTempAPI;
@property (nonatomic, assign) NSInteger normalTimeCounting;
@property (nonatomic, strong) NSString *requestObj;

@end


@implementation CLBetLimitRequestTool

+ (instancetype)sharedInstance{
    static CLBetLimitRequestTool *betInfo = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        betInfo = [[CLBetLimitRequestTool alloc] init];
    });
    return betInfo;
}


- (void)startCheckBetLimit{
    [self.betlimitapi start];
//    //注册倒计时通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeCutDown:) name:GlobalTimerRuning object:nil];
}
- (void)timeCutDown:(NSNotification *)noti{
    
//    self.timerCounting--;
//    if (self.timerCounting == 0) {
//        [self.betlimitapi start];
//        self.timerCounting = self.normalTimeCounting;
//    }
}


#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    
//    if ([self.requestObj isEqualToString:@"T"]) {
//        self.timerCounting = 180;
//        self.normalTimeCounting = 180;
//        //第一个接口
//        if (request.urlResponse.success) {
//            if ([request.urlResponse.responseObject[@"resp"][@"status"] integerValue] == 1) {
//                self.timerCounting = 8;
//                self.normalTimeCounting = 8;
//            }
//        }
//        [self startCheckBetLimit];
//    }else{
//        //购彩屏蔽接口
        if (request.urlResponse.success) {
            if ([request.urlResponse.responseObject[@"resp"][@"ifAuditing"] integerValue] == 0) {
                
                SET_DEFAULTS(Bool, @"bet_limit_status", YES);
                [[NSNotificationCenter defaultCenter] removeObserver:self];
            }else{
                SET_DEFAULTS(Bool, @"bet_limit_status", NO);
            }
        }else{
            SET_DEFAULTS(Bool, @"bet_limit_status", NO);
        }
    
    if (self.betlimitapi) {
        self.betlimitCallBack(DEFAULTS(bool, @"bet_limit_status"));
    }
    
//    }
    
    
   
}

- (void)requestFailed:(CLBaseRequest *)request {
//    if ([self.requestObj isEqualToString:@"T"]) {
//        //第一个接口
//        self.timerCounting = 180;
//        self.normalTimeCounting = 180;
//        [self startCheckBetLimit];
//    }else{
//        //购彩屏蔽接口
        SET_DEFAULTS(Bool, @"bet_limit_status", NO);
//    }
    if (self.betlimitapi) {
        self.betlimitCallBack(DEFAULTS(bool, @"bet_limit_status"));
    }
   
}

- (void)cancelRequest:(CLBaseRequest *)request {
    if (self.betlimitapi) {
        self.betlimitCallBack(DEFAULTS(bool, @"bet_limit_status"));
    }
}


- (CLBetLimitAPI *)betlimitapi{
    if (!_betlimitapi) {
        _betlimitapi = [[CLBetLimitAPI alloc] init];
        _betlimitapi.delegate = self;
    }
    return _betlimitapi;
}
- (CLTabbarTempCheckAPI *)tabbarTempAPI{
    if (!_tabbarTempAPI) {
        _tabbarTempAPI = [[CLTabbarTempCheckAPI alloc] init];
        _tabbarTempAPI.delegate = self;
    }
    return _tabbarTempAPI;
}
@end
