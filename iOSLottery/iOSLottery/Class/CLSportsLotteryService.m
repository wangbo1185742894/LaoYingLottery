//
//  CLSportsLotteryService.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/6/1.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLSportsLotteryService.h"
#import "CLAppContext.h"
#import "CLShowHUDManager.h"
#import "CLLoadingAnimationView.h"
#import "CKNewPayViewController.h"
#import "CLCheckProgessManager.h"
#import "UINavigationController+CLDestroyCurrentController.h"

#import "UITableView+CLScreenCapture.h"
#import "CLScreenCaptureView.h"

#import "CLUmengShareManager.h"
#import <UMSocialUIManager.h>
#import "CLNewbieGuidanceService.h"

#import "CLAlertPromptMessageView.h"
#import "CLAllAlertInfo.h"

#import "CLAllJumpManager.h"

@interface CLSportsLotteryService ()<UMSocialShareMenuViewDelegate>

@property (nonatomic, strong) CLScreenCaptureView *captureView;

@property (nonatomic, strong) CLAlertPromptMessageView *alertView;

@end

@implementation CLSportsLotteryService

- (NSString *)getToken{
    
    return [CLAppContext context].token;
}

- (BOOL)hasNet
{

    return [CLAppContext context].isReachable;
}

- (void)showError:(NSString *)errorMes{
    
    [CLShowHUDManager showInWindowWithText:errorMes type:CLShowHUDTypeOnlyText delayTime:1.f];
}

- (void)startLoading{
    
    [[CLLoadingAnimationView shareLoadingAnimationView] showLoadingAnimationInCurrentViewControllerWithType:CLLoadingAnimationTypeNormal];
}

- (void)stopLoading{
    
    [[CLLoadingAnimationView shareLoadingAnimationView] stop];
}

- (void)createOrderSuccess:(id)orderInfo origin:(UIViewController *)originVC{
    

    [originVC.navigationController pushDestroyViewController:[self createPayViewController:orderInfo PushType:CKPayPushTypeBet] animated:YES];
}

- (void)createContinueOrderSuccess:(id)orderInfo origin:(UIViewController *)originVC
{

    [originVC.navigationController pushViewController:[self createPayViewController:orderInfo PushType:CKPayPushTypeOrderAndFollow] animated:YES];
    
}

- (CKNewPayViewController *)createPayViewController:(id)orderInfo PushType:(CKPayPushType)type
{

    /** 需要优化 兼容篮球 */
    CKNewPayViewController *payVc = [[CKNewPayViewController alloc] init];
    payVc.lotteryGameEn = orderInfo[@"gameEn"]?:@"";
    payVc.pushType = type;
    payVc.orderType = CKOrderTypeJC;
    payVc.hasNotPeriodTime = YES;
    /** 竞彩继续 倒计时弹窗 */
    if (orderInfo[@"endTime"] && [orderInfo[@"endTime"] integerValue]) {
        payVc.periodTime = [orderInfo[@"endTime"] integerValue];
    }
    payVc.payConfigure = orderInfo;
    payVc.hasNotPeriodTime = YES;
    payVc.hidesBottomBarWhenPushed = YES;
    
    return payVc;
}


- (void)checkIsLoginWithComplete:(void (^)())complete{
    
    [[CLCheckProgessManager shareCheckProcessManager] checkIsLoginWithCallBack:complete];
}

- (void)shareMessageWithTitle:(NSString *)title tableView:(UITableView *)tableView
{
   
    self.captureView = [[CLScreenCaptureView alloc] init];

    self.captureView.topTitle = title;
    
    self.captureView.captureImage = [tableView cl_captureImageOfFrame];
    
    [UMSocialUIManager setShareMenuViewDelegate:self];
    
    [CLUmengShareManager umengShareMessageWithImage:[tableView cl_captureShareImageOfContentAndAppIcon:nil]];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.captureView];
    
}

- (void)UMSocialShareMenuViewDidDisappear
{
    [self.captureView removeFromSuperview];
}

- (void)showFootBallNewbieGuidance{
    
    [CLNewbieGuidanceService showNewGuidanceInWindowWithType:CLNewbieGuidanceTypeFootBall];
}

- (void)showBasketBallNewbieGuidance{
    
    [CLNewbieGuidanceService showNewGuidanceInWindowWithType:CLNewbieGuidanceTypeBasketBall];
}

- (void)showRefundExplain
{

    [self.alertView showInWindow];
}

- (CLAlertPromptMessageView *)alertView{
    
    if (!_alertView) {
        _alertView = [[CLAlertPromptMessageView alloc] init];
        _alertView.desTitle = allAlertInfo_RefundInfo;
        _alertView.cancelTitle = @"知道了";
    }
    return _alertView;
}

- (void)goToHomeViewController
{
    [[CLAllJumpManager shareAllJumpManager] open:@"CLHomeViewController"];
}

- (void)goToFootBallViewController
{
    [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"SLListViewController_present/0"] dissmissPresent:NO];
    
//    [[CLAllJumpManager shareAllJumpManager] openDestoryWithURL:[NSString stringWithFormat:@"SLListViewController_present/0"] dismiss:YES];
    
//    [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"SLListViewController_present/0"] dissmissPresent:NO animation:YES];
}

- (void)goToBasketBallViewController
{

    [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"BBMatchBetListController_present/0"] dissmissPresent:NO];
}

@end
