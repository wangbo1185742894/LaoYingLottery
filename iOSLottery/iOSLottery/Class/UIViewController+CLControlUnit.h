//
//  UIViewController+CLControlUnit.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/17.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLLoadingAnimationView;
@interface UIViewController (CLControlUnit)

/**
 报错提示 弹窗

 @param title 提示内容
 */
- (void) show:(NSString*)title;
- (void) show:(NSString*)title delay:(NSTimeInterval)delay;


/**
 展示菊花转圈
 */
- (void) showLoading;

/**
 停止菊花转圈
 */
- (void)stopLoading;
@end
