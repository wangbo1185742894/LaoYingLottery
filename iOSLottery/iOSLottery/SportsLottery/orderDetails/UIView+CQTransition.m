//
//  UIControl+CQTransition.m
//  caiqr
//
//  Created by 洪利 on 2017/4/14.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "UIView+CQTransition.h"

@implementation UIView (CQTransition)


- (void)startAnimationWithTransitionWithStyle:(CQTransitionAnimationType)type{
    [self.layer removeAllAnimations];
    
    if (type == CQTransitionAnimationTypeTwinkle) {
        //渐隐动画
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
        animation.fromValue = [NSNumber numberWithFloat:0.0f];
        animation.toValue = [NSNumber numberWithFloat:1.0f];//这是透明度。
        animation.autoreverses = NO;
        animation.duration = 1.0;
        animation.repeatCount = 1;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
        [self.layer addAnimation:animation forKey:nil];
    }else{
        //创建动画
        CAKeyframeAnimation * keyAnimaion = [CAKeyframeAnimation animation];
        keyAnimaion.keyPath = @"transform.rotation";
        keyAnimaion.values = @[@(-10 / 180.0 * M_PI),@(10 /180.0 * M_PI),@(-10/ 180.0 * M_PI)];//度数转弧度
        keyAnimaion.beginTime = 0;
        keyAnimaion.removedOnCompletion = NO;
        keyAnimaion.fillMode = kCAFillModeForwards;
        keyAnimaion.duration = 0.3;
        keyAnimaion.repeatCount = 1000000;
        [self.layer addAnimation:keyAnimaion forKey:nil];
    }
    
}



- (void)stopAllAnimation{
    [self.layer removeAllAnimations];
}


@end
