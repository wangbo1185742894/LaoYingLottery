//
//  UIButton+SMSCertify.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/5.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "UIButton+SMSCertify.h"
#import <objc/runtime.h>

#define SMSCertifyTotalSec 60

@implementation UIButton (SMSCertify)

- (void) addCertifyDelegate:(id<SMSCertifyDelegate>) delegate {
    
    [self addTarget:self action:@selector(gettingCertifyCode) forControlEvents:UIControlEventTouchUpInside];
    self.smsDelegate = delegate;
}

- (void)gettingCertifyCode {
    
    if (!self.enabled) return;
    
    BOOL canSt = YES;
    if ([self.smsDelegate respondsToSelector:@selector(canStarting)]) {
        canSt = [self.smsDelegate canStarting];
    }
    
    if (!canSt) return;
    
    self.enabled = NO;
    if ([self.smsDelegate respondsToSelector:@selector(startTimeCountDown)]) {
        [self.smsDelegate startTimeCountDown];
    }
    
    //开启计时器
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timerCountDownCurrentSec = SMSCertifyTotalSec;
    
    //初始化倒计时时间
    self.titleLabel.text = [NSString stringWithFormat:@"获取验证码(%zis)",SMSCertifyTotalSec];
    [self setTitle:[NSString stringWithFormat:@"获取验证码(%zis)",SMSCertifyTotalSec] forState:UIControlStateDisabled];
    //开始倒计时
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerCountDown:) userInfo:nil repeats:YES];
    self.timer = timer;
    timer = nil;
    
}


- (void)timerCountDown:(NSTimer*)ti {
    if (self.timerCountDownCurrentSec <= 1)
    {//倒计时结束时
        [ti invalidate];
        ti = nil;
        self.timer = nil;
        self.enabled = YES;
        if ([self.smsDelegate respondsToSelector:@selector(endTimeCountDown)]) {
            [self.smsDelegate endTimeCountDown];
        }
        
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self setTitle:@"获取验证码" forState:UIControlStateDisabled];
    }
    else
    {//倒计时中
        NSInteger num = --self.timerCountDownCurrentSec;
        [self setTitle:[NSString stringWithFormat:@"获取验证码(%zis)",num] forState:UIControlStateDisabled];
    }

}


#pragma mark - Property

static const char kSMSCertifyTimer;
static const char kSMSCertifyCntSec;
static const char kSMSCertifyDelegate;

- (void)setTimer:(NSTimer *)timer {
    
    objc_setAssociatedObject(self, &kSMSCertifyTimer, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimer *)timer {
    
    return objc_getAssociatedObject(self, &kSMSCertifyTimer);
}

- (void)setTimerCountDownCurrentSec:(NSTimeInterval)timerCountDownCurrentSec {
    
    objc_setAssociatedObject(self, &kSMSCertifyCntSec, @(timerCountDownCurrentSec), OBJC_ASSOCIATION_RETAIN);
}

- (NSTimeInterval)timerCountDownCurrentSec {
    
    NSNumber *num = objc_getAssociatedObject(self, &kSMSCertifyCntSec);
    
    
    return [num floatValue];
}

- (void)setSmsDelegate:(id<SMSCertifyDelegate>)smsDelegate {
    
    objc_setAssociatedObject(self, &kSMSCertifyDelegate, smsDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<SMSCertifyDelegate>)smsDelegate {
    
    return objc_getAssociatedObject(self, &kSMSCertifyDelegate);
}

@end
