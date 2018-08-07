//
//  CLCheckProgessManager.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/28.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLCheckProgessManager.h"
#import "CLAppContext.h"
#import "CLAllJumpManager.h"
#import "CLPersonalMsgHandler.h"
#import "CLUserCenterPageConfigure.h"
#import "CLSettingAdapter.h"
static NSString *loginCallBackName = @"loginCallBack";
static NSString *userCertifyCallBackName = @"userCertifyCallBack";

@interface CLCheckProgessManager ()


@end

@implementation CLCheckProgessManager
+ (instancetype)shareCheckProcessManager{
    
    static CLCheckProgessManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[CLCheckProgessManager alloc] init];
    });
    return manager;
}

#pragma mark - 校验是否登录
- (void)checkIsLoginWithCallBack:(checkProcessCallBack)callBack{
    
    //校验 是否 登录
    if ([[CLAppContext context] appLoginState]) {
        //已登录 直接回调
        callBack();
    }else{
        //未登录 ，跳转登录
        //注册匿名回调
        [[CLAllJumpManager shareAllJumpManager] registerCallBack:loginCallBackName block:^(NSDictionary *params) {
            
            callBack();
        }];
        //跳转登录
        [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLLoginViewController_present/%@", loginCallBackName]];
    }
}
#pragma mark - 校验是否实名
- (void)checkIsUserCertifyWithCallBack:(checkProcessCallBack)callBack{
    
    //校验 是否 实名认证
    if ([CLPersonalMsgHandler identityAuthentication]) {
        //已实名认证
        callBack();
    }else{
        //未实名认证
        //注册匿名回调
        [[CLAllJumpManager shareAllJumpManager] registerCallBack:userCertifyCallBackName block:^(NSDictionary *params) {
            callBack();
        }];
        [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLUserCertifyViewController_push/%@", userCertifyCallBackName]];
    }
    
}
#pragma mark - 校验银行卡
- (void)checkhasBankCardWithSelectIndex:(NSInteger)selectIndex CallBack:(checkProcessCallBack)callBack{
    
    if (selectIndex < 0) {
        
        //注册回调
        [[CLAllJumpManager shareAllJumpManager] registerCallBack:@"allJump_AddBankCallBack" block:^(NSDictionary *params) {
            
            callBack();
        }];
        [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLAddBankCardViewController_push/2//%@", @"allJump_AddBankCallBack"]];
    }else{
        callBack();
    }
}
#pragma mark - 校验支付密码
- (void)checkHasPayPassWordWithCallBack:(checkProcessCallBack)callBack{
    
    if (![CLSettingAdapter hasPayPwdStatus]) {
        //未设置支付密码 - 设置
        [[CLAllJumpManager shareAllJumpManager] registerCallBack:@"allJump_SetPayPwdCallBack" block:^(NSDictionary *params) {
            
            callBack();
        }];
        [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CQSettingPaymentPwdViewController_present/%@", @"allJump_SetPayPwdCallBack"]];
        return;
    } else {
        //已设置支付密码 - 校验
        callBack();
    }
}

#pragma mark - 提现的校验流程
- (void)withdrawCheckProcessWithSelectIndex:(NSInteger)selectIndex callBack:(checkProcessCallBack)callBack{
    __weak __typeof(&*self)weakSelf = self;
    
    [self checkhasBankCardWithSelectIndex:selectIndex CallBack:^{
        
        [weakSelf checkIsUserCertifyWithCallBack:^{
            
            [weakSelf checkHasPayPassWordWithCallBack:^{
                callBack();
            }];
        }];
    }];   
}

@end
