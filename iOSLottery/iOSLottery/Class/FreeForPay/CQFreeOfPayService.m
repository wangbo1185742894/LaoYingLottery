//
//  CQFreeOfPayService.m
//  caiqr
//
//  Created by 洪利 on 2017/3/9.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CQFreeOfPayService.h"
#import "CQFreeOfPaymentViewController.h"
#import "CQFreeOfpayModel.h"
#import "CQCustomRequestAPI.h"
#import "CLSetFreePayQuotaAPI.h"
#import "CLAppContext.h"
#import "CLUserBaseInfo.h"
#import "CLShowHUDManager.h"
#import "CLMainTabbarViewController.h"
#import "AppDelegate.h"

@interface CQFreeOfPayService ()<CLRequestCallBackDelegate>

@property (nonatomic, strong) CQCustomRequestAPI *request;
@property (nonatomic, strong) CLSetFreePayQuotaAPI *freePayApi;

@property (nonatomic, copy) void (^ checkComplete)();
@property (nonatomic, copy) void (^ setFreeComplete)();
@end


@implementation CQFreeOfPayService

+ (instancetype)allocWithWeakViewController:(UIViewController *)weakViewController{
    CQFreeOfPayService *selfService = [[CQFreeOfPayService alloc] init];
    selfService.weakSelfViewController = weakViewController;
    
    return selfService;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.request = [[CQCustomRequestAPI alloc] init];
        self.request.delegate = self;
        
        self.freePayApi = [[CLSetFreePayQuotaAPI alloc] init];
        self.freePayApi.delegate = self;
    }
    return self;
}

//外部调用
- (void)isAlreadyFreeOfPayServiceWithChannalType:(paymentChannelType)type complete:(void (^)())complete{
    CLMainTabbarViewController * viewController = (CLMainTabbarViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;
    UINavigationController *nav = viewController.selectedViewController;
    UIViewController *currentVC = nav.topViewController;
    self.weakSelfViewController = currentVC;
    self.checkComplete = complete;
    if ([self checkPay:type]) {
        [self.request start];
    }else{
        self.checkComplete?self.checkComplete():nil;
    }
}
- (void)resetFreeOfPayWithisNeverNotify:(NSString *)never_notify
                                  quato:(NSString *)quato
                              iskaitong:(NSString *)isKaitong
                               complete:(void (^)())complete{
    
    self.freePayApi.neverNotify = never_notify;
    self.freePayApi.free_pay_amount = quato;
    self.freePayApi.free_pay_status = isKaitong;
    self.freePayApi.is_click = [isKaitong isEqualToString:@"1"]?@"0":@"1";
    self.setFreeComplete = ^(){
        
        [isKaitong isEqualToString:@"1"]?[CLShowHUDManager showInWindowWithText:@"已开通" type:CLShowHUDTypeOnlyText delayTime:0.5]:nil;
        !complete ? : complete();
    };
    
    [self.freePayApi start];
}
- (BOOL)checkPay:(paymentChannelType)paytype{
    if (paytype == paymentChannelTypeAccountBalance || paytype == paymentChannelTypeOnlyRedParkets) {
        BOOL isAlreadyfree = [CLAppContext context].userMessage.user_info.free_pay_pwd_status;
        BOOL isHasPwd = [CLAppContext context].userMessage.user_info.has_pay_pwd;
        //已设置密码并且已开通小额免密则不执行小额免密快捷设置模式
            return !(isHasPwd && isAlreadyfree);
    }
    return NO;
}

/** 请求成功 */
- (void)requestFinished:(CLBaseRequest *)request{
    
    if (self.request == request) {
        if (request.urlResponse.success) {
            //        request.urlResponse.resp
            if (request.urlResponse.resp && [request.urlResponse.resp count]){
                self.mainDataModel = [CQFreeOfpayModel mj_objectWithKeyValues:[request.urlResponse.resp firstObject]];
//                if (self.mainDataModel.default_quota_list.count != 0 && self.mainDataModel.is_show) {
                    [CQFreeOfPaymentViewController creatFreeOfPayViewControllerWithPushViewController:self.weakSelfViewController service:self complete:^{
                        self.checkComplete?self.checkComplete():nil;
                    }];
                    return;
//                }
            }
        }
        self.checkComplete?self.checkComplete():nil;
    }else{
        
        if (request.urlResponse.success) {
            
            [CLAppContext context].userMessage.user_info.free_pay_pwd_status = [request.urlResponse.resp[0][@"free_pay_pwd_status"] integerValue] == 1;
            
            [CLAppContext context].userMessage.user_info.free_pay_pwd_quota = [request.urlResponse.resp[0][@"free_pay_pwd_quota"] longLongValue];
            
            !self.setFreeComplete ? : self.setFreeComplete();
        }
        
    }
    
}

/** 请求失败 */
- (void)requestFailed:(CLBaseRequest *)request{
    //    request.urlResponse.errorMessage
    if (self.request == request) {
        self.checkComplete?self.checkComplete():nil;
    }
}
@end
