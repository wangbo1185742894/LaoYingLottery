//
//  UINavigationController+CLDestroyCurrentController.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/5.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (CLDestroyCurrentController)

- (void)pushDestroyViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end

@interface UIViewController (CQTransition)

- (UIViewController*)searchBeforeNavi;

@end
