//
//  CQBasicAnimation.m
//  caiqr
//
//  Created by huangyuchen on 16/8/11.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CQBasicAnimation.h"

@implementation CQBasicAnimation
//添加位移动画
+ (CAAnimation*)createPositionAnimateDuration:(NSTimeInterval)duration
                                positionValus:(NSArray*)valus
                              timingFunctions:(NSArray*)timingFunctions
                                    beginTime:(CFTimeInterval)beginTime
{
    CAKeyframeAnimation* positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = valus;
    positionAnimation.duration = duration;
    positionAnimation.beginTime = beginTime;
    positionAnimation.removedOnCompletion = NO;
    positionAnimation.fillMode = kCAFillModeForwards;
    if (timingFunctions && timingFunctions.count > 0) {
        positionAnimation.timingFunctions = timingFunctions;
    }
    return positionAnimation;
}
//添加透明动画
+ (CAAnimation*)createOpacityAnimateDuration:(NSTimeInterval)duration
                              timingFunction:(CAMediaTimingFunction*)timingFunction
                                   fromValue:(CGFloat)fromValue
                                     toValue:(CGFloat)toValue
                                   beginTime:(CFTimeInterval)beginTime
{
    CABasicAnimation* manOpacityAnimate = [CABasicAnimation animationWithKeyPath:@"opacity"];
    manOpacityAnimate.fromValue = [NSNumber numberWithFloat:fromValue];
    manOpacityAnimate.toValue = [NSNumber numberWithFloat:toValue];
    manOpacityAnimate.beginTime = beginTime;
    manOpacityAnimate.duration = duration;
    if (timingFunction) {
        manOpacityAnimate.timingFunction = timingFunction;
    }
    manOpacityAnimate.fillMode = kCAFillModeForwards;
    manOpacityAnimate.removedOnCompletion = NO;
    
    return manOpacityAnimate;
    
}
//添加形变动画
+ (CAAnimation*)createScaleAnimateDuration:(NSTimeInterval)duration
                            timingFunction:(CAMediaTimingFunction*)timingFunction
                                        sx:(CGFloat)x
                                        sy:(CGFloat)y
                                        sy:(CGFloat)z
                                 beginTime:(CFTimeInterval)beginTime{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animation];
    //动画结束值
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(x, y, z)];
    scaleAnimation.duration = duration;
    scaleAnimation.beginTime = beginTime;
    if (timingFunction) {
        scaleAnimation.timingFunction = timingFunction;
    }
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.keyPath = @"transform";
    return scaleAnimation;
}
//添加旋转动画
+ (CAAnimation*)createRotationAnimateDuration:(NSTimeInterval)duration
                            timingFunction:(CAMediaTimingFunction*)timingFunction
                                     angle:(CGFloat)angle
                                         x:(CGFloat)x
                                         y:(CGFloat)y
                                         z:(CGFloat)z
                                  repeatCount:(NSInteger)count
                                 beginTime:(CFTimeInterval)beginTime{
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    rotation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(angle, x, y, z)];
    rotation.duration = duration;
    rotation.beginTime = beginTime;
    //旋转效果是否累计（下一次的动画执行是否接着刚才结束的状态）
    rotation.cumulative = YES;
    //动画重复执行的次数
    rotation.repeatCount = count;
    
    if (timingFunction) {
        rotation.timingFunction = timingFunction;
    }
    //不反弹
    rotation.removedOnCompletion = NO;
    rotation.fillMode = kCAFillModeForwards;
    return rotation;
}


//添加组动画
+ (CAAnimationGroup *)addAnimateGruopToLayer:(CALayer*)layer
                    animations:(NSArray*)animations
                      duration:(NSTimeInterval)duration
{
    CAAnimationGroup *animateGroup = [CAAnimationGroup animation];
    animateGroup.animations = animations;
    animateGroup.duration = duration;
    animateGroup.removedOnCompletion = NO;
    animateGroup.fillMode = kCAFillModeForwards;
    return animateGroup;
}

@end
