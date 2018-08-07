//
//  UIViewController+CLTransition.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/17.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "UIViewController+CLTransition.h"
#import "CLMainTabbarViewController.h"
@implementation UIViewController (CLTransition)

- (UIViewController*)searchBeforeNavi
{
    UIViewController* resultViewController = self;
    while (resultViewController.presentingViewController) {
        resultViewController = resultViewController.presentingViewController;
        if ([resultViewController isKindOfClass:[UINavigationController class]]) {
            break;
        } else if ([resultViewController isKindOfClass:[CLMainTabbarViewController class]]) {
            
            UIViewController *selectedVC = ((CLMainTabbarViewController*)resultViewController).selectedViewController;
            if (selectedVC.presentedViewController) {
                return selectedVC.presentedViewController;
            }else{
                return selectedVC;
            }
        }
    }
    if ([resultViewController isKindOfClass:[UINavigationController class]]) {
        return resultViewController;
    } else {
        return nil;
    }
}

@end
