//
//  UINavigationController+CLDestroyCurrentController.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/5.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "UINavigationController+CLDestroyCurrentController.h"
#import "CLBaseViewController.h"
#import "CLMainTabbarViewController.h"
@implementation UINavigationController (CLDestroyCurrentController)
- (void)pushDestroyViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    //存在需要删除的类
    BOOL validNavi = (self.viewControllers.count >= 1);
    if (validNavi) {
        //是有效导航 直接将需要销毁的类删除
        NSMutableArray *tempArrays = [self.viewControllers mutableCopy];
        [tempArrays removeLastObject];
        
        //删除之后判断当前堆栈中是否有控制器
        if (tempArrays.count > 0) {
            //存在控制器 判断栈顶控制器与目标控制器是否相同
            NSString* resultName = [NSString stringWithUTF8String:object_getClassName([tempArrays lastObject])];
            NSString* destionVC = [NSString stringWithUTF8String:object_getClassName(viewController)];
            //相同 将栈顶控制器删除
            if ([resultName isEqualToString:destionVC]) {
                [tempArrays removeLastObject];
            }
            //判断此时堆栈中是否有控制器 有控制器将目标控制器加入堆栈中 进行push
            if (tempArrays.count > 0) {
                [tempArrays addObject:viewController];
                if (self.presentedViewController) {
                    [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
                }
                [self setViewControllers:tempArrays animated:animated];
                return;
            }
        }
    }
    //是rootViewController 寻找上一个Navi
    UINavigationController* resultViewController = (UINavigationController*)[self searchBeforeNavi];
    if (resultViewController) {
        [resultViewController dealwithNavipushViewController:viewController animated:animated];
    }
}

/** 处理销毁压栈操作  跨堆栈处理 */
- (void)dealwithNavipushViewController:(UIViewController*)viewController animated:(BOOL)animated
{
    BOOL validNavi = (self.viewControllers.count >= 1);
    if (validNavi) {
        //是有效导航 直接将标记销毁的类删除
        NSMutableArray *tempArrays = [self.viewControllers mutableCopy];
        
        if (tempArrays.count > 0) {
            //存在控制器 判断栈顶控制器与目标控制器是否相同
            NSString* resultName = [NSString stringWithUTF8String:object_getClassName([tempArrays lastObject])];
            NSString* destionVC = [NSString stringWithUTF8String:object_getClassName(viewController)];
            //相同 将栈顶控制器删除
            if ([resultName isEqualToString:destionVC]) {
                [tempArrays removeLastObject];
            }
            //判断此时堆栈中是否有控制器 有控制器将目标控制器加入堆栈中 进行push
            if (tempArrays.count > 0) {
                [tempArrays addObject:viewController];
                if (self.presentedViewController) {
                    [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
                }
                [self setViewControllers:tempArrays animated:animated];
                return;
            }
        }
    }
    //是rootViewController 寻找上一个Navi
    UINavigationController* resultViewController = (UINavigationController*)[self searchBeforeNavi];
    if (resultViewController) {
        [self dealwithNavipushViewController:resultViewController animated:animated];
    }
}
@end


@implementation UIViewController(CQTransition)

- (UIViewController*)searchBeforeNavi
{
    UIViewController* resultViewController = self;
    while (resultViewController.presentingViewController) {
        resultViewController = resultViewController.presentingViewController;
        if ([resultViewController isKindOfClass:[UINavigationController class]]) {
            break;
        } else if ([resultViewController isKindOfClass:[CLMainTabbarViewController class]]) {
            return ((CLMainTabbarViewController*)resultViewController).selectedViewController;
        }
    }
    if ([resultViewController isKindOfClass:[UINavigationController class]]) {
        return resultViewController;
    } else {
        return nil;
    }
}

@end
