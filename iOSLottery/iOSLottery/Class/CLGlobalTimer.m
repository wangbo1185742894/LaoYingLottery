//
//  CLGlobalTimer.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/12.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLGlobalTimer.h"
#import "CLConfigMessage.h"

@interface CLGlobalTimer (){
    
    dispatch_source_t __globalTimer;
}
@end

@implementation CLGlobalTimer

#pragma mark - 创建单例
+ (CLGlobalTimer *)shareGlobalTimer
{
    static CLGlobalTimer *globalTimer = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        globalTimer = [[self alloc] init];
    });
    return globalTimer;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createTime];
    }
    return self;
}

- (void)createTime{
    
    
    //0 获取一个全局的并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //1. 定义一个定时器
    /**
     第一个参数:说明定时器的类型
     第四个参数:GCD的回调任务添加到那个队列中执行，如果是主队列则在主线程执行     */
    dispatch_source_t  timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    __globalTimer = timer;
    //这里创建的 timer, 是一个局部变量,由于 Block 回调定时器,因此,必须保证 timer 被强引用;    self.timer = timer;
    dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC);
    /**     *
     <#dispatch_source_t source#>:给哪个定时器设置时间
     <#dispatch_time_t start#>:定时器立即启动的开始时间
     <#uint64_t interval#>:定时器开始之后的间隔时间
     <#uint64_t leeway#>:定时器间隔时间的精准度,传入0代表最精准,尽量让定时器精准,注意: dispatch 的定时器接收的时间是 纳秒
     */
    uint64_t interval = 1.0 * NSEC_PER_SEC;
    //2设置定时器的相关参数:开始时间,间隔时间,精准度等
    dispatch_source_set_timer( timer, startTime, interval, 0 * NSEC_PER_SEC);
    //3.设置定时器的回调方法
    dispatch_source_set_event_handler(timer, ^{
        [self globalTimerRun:__globalTimer];
    });
    //4.开启定时器
    dispatch_resume(timer);
}

- (void)globalTimerRun:(dispatch_source_t)timer{
    
    dispatch_async(dispatch_get_main_queue(),^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:GlobalTimerRuning object:nil];
    });
}
@end
