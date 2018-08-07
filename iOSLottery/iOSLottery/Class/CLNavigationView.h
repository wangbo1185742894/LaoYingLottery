//
//  CLNavigationView.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//
///// 彩种上方 的 navigationView  (即点选玩法的按钮)
#import <UIKit/UIKit.h>

@interface CLNavigationView : UIView
@property (nonatomic, copy) void(^leftViewBlock)();
@property (nonatomic, copy) void(^titleViewBlock)();
@property (nonatomic, copy) void(^rightViewBlock)();
@property (nonatomic, strong) NSString *navigationTitle;
/**
 箭头旋转
 
 @param isRotation yes 表示旋转  no 表示复原
 */
- (void)midImageViewIsRotation:(BOOL)isRotation;

/**
 是否显示旋转image
 */
- (void)setShowMidImage:(BOOL)show;
/**
 是否显示右侧助手
 */
- (void)setShowRightBtn:(BOOL)show;

@end
