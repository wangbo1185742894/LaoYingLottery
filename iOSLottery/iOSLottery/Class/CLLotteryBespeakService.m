//
//  CLLotteryBespeakService.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLLotteryBespeakService.h"
#import "CLLotteryBespeakViewController.h"
#import "CLTools.h"
#import <objc/runtime.h>
#import "CLTools.h"
#import "CLLotteryBespeakApi.h"
#import "CLMainTabbarViewController.h"
#import "AppDelegate.h"
#import "CLAllJumpManager.h"
#import "CLLoadingAnimationView.h"
@interface CLLotteryBespeakService ()<CLRequestCallBackDelegate>

@property (nonatomic, strong) NSString* lottery_order_id;

@property (nonatomic, copy) void(^bespeakLotteryCompletion)(void);

@property (nonatomic, strong) CLLotteryBespeakApi *lotteryBespeakApi;

@property (nonatomic, strong) UIViewController *currentViewController;

@end

@implementation CLLotteryBespeakService

+ (void)runBespeakServiceWithOrderId:(NSString*)order_id
                          completion:(void(^)(void)) completion
{
    CLLotteryBespeakService* service = [[CLLotteryBespeakService alloc] init];
    service.lottery_order_id = order_id;
    service.bespeakLotteryCompletion = completion;
    
//    CLMainTabbarViewController * viewController = (CLMainTabbarViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;
//    UINavigationController *nav = viewController.selectedViewController;
//    UIViewController *currentVC = nav.topViewController;
    service.currentViewController = [CLTools getCurrentViewController];
    
    [service setLotteryService:service];
    [service startService];
}
#pragma mark ------------ delegate ------------
- (void)requestFinished:(CLBaseRequest *)request{
    
    if (request.urlResponse.success || request.urlResponse.resp) {
        
        [self gotoLotteryBespeakViewContrllerWithInfo:[CLBespeakLotteryModel mj_objectWithKeyValues:request.urlResponse.resp]];
    }else{
        [self finishBespeakAction];
    }
    [[CLLoadingAnimationView shareLoadingAnimationView] stop];
}

- (void)requestFailed:(CLBaseRequest *)request{
    
    [[CLLoadingAnimationView shareLoadingAnimationView] stop];
    self.bespeakLotteryCompletion ? self.bespeakLotteryCompletion() : nil;
    
}
static char CQLotteryBespeakServiceKey;
/** 增加属性 将自己增加到对应类中,保证实例不会被释放 */
- (void)setLotteryService:(CLLotteryBespeakService*)service
{
    objc_setAssociatedObject(self.currentViewController, &CQLotteryBespeakServiceKey,
                             service,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/** 开始进行请求 */
- (void)startService
{
    self.lotteryBespeakApi = [[CLLotteryBespeakApi alloc] init];
    self.lotteryBespeakApi.delegate = self;
    self.lotteryBespeakApi.order_Id = self.lottery_order_id;
    [[CLLoadingAnimationView shareLoadingAnimationView] showLoadingAnimationWithView:self.currentViewController.view type:CLLoadingAnimationTypeNormal];
    [self.lotteryBespeakApi start];
}

/** 跳转预约页面进行动画展示 */
- (void)gotoLotteryBespeakViewContrllerWithInfo:(CLBespeakLotteryModel*)info
{
    if (info.ifShowPostName == 0) {
        self.bespeakLotteryCompletion ? self.bespeakLotteryCompletion() : nil;
        return;
    }
    WS(_weakSelf)
    CLLotteryBespeakViewController *lotteryBespeakVC = [[CLLotteryBespeakViewController alloc] init];
    lotteryBespeakVC.lotteryBespeak = info;
    
//    CLMainTabbarViewController * viewController = (CLMainTabbarViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;

    lotteryBespeakVC.snapView = snapshot([CLTools getCurrentViewController].view.window);
    
    lotteryBespeakVC.bespeakCompletion = ^{
        [_weakSelf finishBespeakAction];
    };
    //获取当前栈顶vc
    
    [self.currentViewController presentViewController:lotteryBespeakVC animated:NO completion:nil];
}

/** 预约动画完成后 执行操作 */
- (void)finishBespeakAction
{
    [self setLotteryService:nil];
    if (self.bespeakLotteryCompletion) {
        self.bespeakLotteryCompletion();
    }
}

@end
