//
//  CLLoadingAnimationView.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/5.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , CLLoadingAnimationType) {
    
    CLLoadingAnimationTypeNormal = 0, //普通菊花
    CLLoadingAnimationTypeGrayCircle //灰色转圈
};

@interface CLLoadingAnimationView : UIView

/**
 单例

 @return 返回加载动画View
 */
+ (CLLoadingAnimationView *)shareLoadingAnimationView;
/**
 添加加载动画

 @param superView 添加在View上
 @param loadingType  加载动画类型
 */
- (void)showLoadingAnimationWithView:(UIView *)superView type:(CLLoadingAnimationType)loadingType;


/**
 将菊花动画添加在当前视图上

 @param loadingType 类型
 */
- (void)showLoadingAnimationInCurrentViewControllerWithType:(CLLoadingAnimationType)loadingType;
/**
 加载动画停止
 */
- (void)stop;
@end
