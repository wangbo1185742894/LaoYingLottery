//
//  CKPayConfig.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/5/5.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CKPayConfig.h"
#import "CLAppContext.h"
#import "CLUserBaseInfo.h"
#import "CLUserCertifyViewController.h"
#import "CLPayCardListViewController.h"
#import "CLShowHUDManager.h"
#import "CLLoadingAnimationView.h"
#import "CLUserBaseInfo.h"
#import "CLConfigAPIMessage.h"
#import "CLCheckTokenManager.h"
@interface CKPayConfig ()

@property (nonatomic, strong) CLCheckTokenManager *checkToken;

@end

@implementation CKPayConfig

- (NSString *)getUserToken{
    
    return [CLAppContext context].token;
}

- (NSString *)token{
    
    return [CLAppContext context].token;
}

- (BOOL)authRealNameStatus{
    
    return ([[CLAppContext context] userMessage].user_info.real_name && [[CLAppContext context] userMessage].user_info.real_name.length > 0);
}

- (BOOL)ownPayPwdStatus{
    
    return [[CLAppContext context] userMessage].user_info.has_pay_pwd;
}

- (BOOL)freePaypwdStatus{
    
    
    return [[CLAppContext context] userMessage].user_info.free_pay_pwd_status;
}

- (long long)freePaypwdQuota{
    
    return [[CLAppContext context] userMessage].user_info.free_pay_pwd_quota * 100;
}

- (double)accountBalance{
    
    return [[CLAppContext context] userMessage].account_info.account_balance;
}

- (NSString *)urlScheme{
    
    
    return [[CLAppContext context] url_Scheme];
}

- (NSString *)payHost{
    
    return @"lottery";
}

- (NSString *)payH5UrlVersion
{
    return nil;
}

- (NSString *)payH5ClientType{
    return nil;
}


- (NSString *)onlyRedPacketPayUrlPrefix {
    NSString *url = nil;
    if (API_Environment == 0 || API_Environment == 3) {
        url = @"https://cashier.caiqr.cn/";
    }else{
        url = @"https://cashier2.caiqr.com/";
    }
    
    return url;
}

- (UIViewController<CKPaymentVerifyCallBackInterface> *)realNameViewController {
    
    CLUserCertifyViewController* idAuthen = [[CLUserCertifyViewController alloc] init];
    return idAuthen;
}

- (UIViewController<CKPaymentVerifyCallBackInterface> *)cardFrontViewController {
    
    CLPayCardListViewController* cardVC = [[CLPayCardListViewController alloc] init];
    return cardVC;
}
//toast 错误信息  需外部实现
- (void)showError:(NSString *)errorMes{
    
    [CLShowHUDManager showInWindowWithText:errorMes type:CLShowHUDTypeOnlyText delayTime:0.5];
}
//加载动画
- (void)startLoading{
    
    [[CLLoadingAnimationView shareLoadingAnimationView] showLoadingAnimationInCurrentViewControllerWithType:CLLoadingAnimationTypeNormal];
}
- (void)stopLoading{
    
    [[CLLoadingAnimationView shareLoadingAnimationView] stop];
}

//支付回调处理
- (void)backPayActionWithObj:(id)obj isException:(BOOL)isException OrderID:(NSString *)idString ContentController:(UIViewController *)contentController{
    
    
}

//
- (Class)ckInheritAPIClass{
    
    return NSClassFromString(@"CLCaiqrBusinessRequest");
}


- (void (^)(BOOL, long long))paymentBackAndSetFree{
    
    void (^freeBackBlock)(BOOL freeStatus, long long pwd_amount) = ^(BOOL freeStatus, long long pwd_amount){
        [CLAppContext context].userMessage.user_info.free_pay_pwd_status = freeStatus;
        [CLAppContext context].userMessage.user_info.free_pay_pwd_quota = pwd_amount;
    };
    return freeBackBlock;
}

- (void (^)(void))pamentNoSetPwdBack{
    
    void(^changePWDBlock)(void) = ^{
        //更新userInfo;
        WS(_weakSelf)
        self.checkToken = [[CLCheckTokenManager alloc] init];
        self.checkToken.destroyCheckTokenManager = ^{
            _weakSelf.checkToken = nil;
        };
        [self.checkToken checkUserToken];
        
    };
    return changePWDBlock;
}

- (NSString *)pay_version{
    
    return [CLAppContext payVersion];
}
@end
