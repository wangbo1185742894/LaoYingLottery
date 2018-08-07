//
//  CLPushActionManager.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/6/2.
//  Copyright © 2017年 caiqr. All rights reserved.
//  

#import "CLPushActionManager.h"
#import "CLNativePushService.h"
#import "CLNotificationUtils.h"
@implementation CLPushActionManager

+ (instancetype)sharePushActionManager{
    
    static CLPushActionManager *push = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        push = [[CLPushActionManager alloc] init];
    });
    return push;
}

- (void)pushUrlWithUrl:(NSString *)pushUrl{
    
    self.pushUrl = pushUrl;
    //判断当前如果会展示活动页 则等待通知再执行跳转
    if (self.isStart) {
        //有活动页 则添加通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushPage) name:CLLaunchActivityViewClose object:nil];
    }else{
        [CLNativePushService pushNativeUrl:self.pushUrl];
    }
    self.isStart = NO;
}

- (void)pushPage{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [CLNativePushService pushNativeUrl:self.pushUrl];
}


@end
