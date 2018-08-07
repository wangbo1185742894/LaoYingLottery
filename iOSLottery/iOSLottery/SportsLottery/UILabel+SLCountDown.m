//
//  UILabel+SLCountDown.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/6/19.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "UILabel+SLCountDown.h"
#import <objc/runtime.h>

static const char *timerKey = "timer";

static const char *secondsKey = "seconds";

static const char *endTextKey = "endtext";

@implementation UILabel (SLCountDown)

- (void)dealloc
{
    [self stopCountDown];
}

- (void)stopCountDown
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)setCountDownText:(NSString *)text;
{
    
    if (![text isKindOfClass:[NSString class]]){
        
        NSLog(@"倒计时输入数据类型错误!");
        return;
    }
    
    self.seconds = [NSNumber numberWithInteger:[text integerValue]];
    
    self.text = [self getMMSSFromSS:[text integerValue]];
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
    
    //    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)countDown:(NSTimer *)timer
{
    
    NSInteger seconds = [self.seconds integerValue];
    
    seconds --;
    
    self.text = [self getMMSSFromSS:seconds];
    
    self.seconds = [NSNumber numberWithInteger:seconds];
    
}

//传入 秒  得到  xx分钟xx秒
- (NSString *)getMMSSFromSS:(NSInteger )totalTime
{
    
    NSInteger seconds = totalTime;
    
    if (totalTime == -1) {
        
        [self.timer invalidate];
        self.timer = nil;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SLOrderDetailsCountDownEnd" object:nil];
        
        return @"00分:00秒";
    }
    //    //format of minute
    //    NSString *str_minute = [NSString stringWithFormat:@"%ld",seconds/60];
    //    //format of second
    //    NSString *str_second = [NSString stringWithFormat:@"%ld",seconds%60];
    //    //format of time
    //    NSString *format_time = [NSString stringWithFormat:@"%@分钟%@秒",str_minute,str_second];
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@时%@分%@秒",str_hour,str_minute,str_second];
    
    //NSLog(@" ##### %ld ###########",[str_hour integerValue]);
    
    if ([str_hour integerValue] < 1) {
        
        format_time = [NSString stringWithFormat:@"%@分%@秒",str_minute,str_second];
    }else{
    
        format_time = [NSString stringWithFormat:@"%@时%@分",str_hour,str_minute];
    }
    
    //NSLog(@"format_time : %@",format_time);
    
    return format_time;
    
}

- (void)setTimer:(NSTimer *)timer
{
    objc_setAssociatedObject(self, &timerKey, timer, OBJC_ASSOCIATION_RETAIN);
}

- (NSTimer *)timer
{
    return objc_getAssociatedObject(self, &timerKey);
}

- (void)setSeconds:(NSNumber *)seconds
{
    
    objc_setAssociatedObject(self, &secondsKey, seconds, OBJC_ASSOCIATION_RETAIN);
}

- (NSNumber *)seconds
{
    
    return objc_getAssociatedObject(self, &secondsKey);
}

- (void)setCountDownEndText:(NSString *)countDownEndText
{
    
    objc_setAssociatedObject(self, &endTextKey, countDownEndText, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)countDownEndText
{
    if (objc_getAssociatedObject(self, &endTextKey) == nil) {
        
        self.countDownEndText = @"支付截止";
        
    }
    
    return objc_getAssociatedObject(self, &endTextKey);
}


@end
