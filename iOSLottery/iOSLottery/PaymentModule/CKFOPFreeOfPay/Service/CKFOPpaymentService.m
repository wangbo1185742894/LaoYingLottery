//
//  CKFOPpaymentService.m
//  caiqr
//
//  Created by 洪利 on 2017/4/27.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKFOPpaymentService.h"
#import "CKFOPModel.h"
#import "CKFOPAlertViewController.h"
#import "CKPayClient.h"
@implementation CKFOPpaymentService
+ (void)isAlreadyFreeOfPayServiceIfNeedPassword:(BOOL)isNeedPassword weakViewController:(UIViewController *)weakViewController block:(void (^)(id))complete{
    CKFOPpaymentService *mySelf = [CKFOPpaymentService allocWithWeakViewController:weakViewController];
    if (isNeedPassword) {
        //如果是需要输入密码的渠道
        BOOL isAlreadyfree = [[CKPayClient sharedManager].intermediary freePaypwdStatus];
        BOOL isHasPwd = [[CKPayClient sharedManager].intermediary ownPayPwdStatus];
        //已设置密码并且已开通小额免密则不执行小额免密快捷设置模式
        if (isHasPwd && isAlreadyfree) {
            mySelf.isNeedShowAlter = NO;
            complete?complete(nil):nil;
        }else{
            mySelf.isNeedShowAlter = YES;
            [mySelf showFreeOfPayAlertView:complete];
        }
    }else{
        //不是直接返回
        !complete?:complete(nil);
    }
    
}

- (void)showFreeOfPayAlertView:(void (^)(id))complete{
    
    [self isAlreadyFreeOfPayService:^(id obj) {
        self.mainDataModel = [CKFOPModel objectWithKeyValues:[obj firstObject]];
        if (self.mainDataModel.default_quota_list.count != 0 && self.mainDataModel.is_show) {
            [CKFOPAlertViewController creatFreeOfPayViewControllerWithPushViewController:self.weakSelfViewController service:self complete:^ (id obj){
                complete?complete(obj):nil;
            }];
        }else{
            complete?complete(obj):nil;
        }
    }];
    

}


+ (instancetype)allocWithWeakViewController:(UIViewController *)weakViewController{
    CKFOPpaymentService *selfService = [[CKFOPpaymentService alloc] init];
    selfService.weakSelfViewController = weakViewController;
    return selfService;
}


@end
