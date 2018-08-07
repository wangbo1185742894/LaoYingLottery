//
//  SLBasicAnimation.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/6/14.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLBasicAnimation.h"

@implementation SLBasicAnimation

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
                                     fromX:(CGFloat)fromX
                                     fromY:(CGFloat)fromY
                                     fromZ:(CGFloat)fromZ
                                       toX:(CGFloat)toX
                                       toY:(CGFloat)toY
                                       toZ:(CGFloat)toZ
                                 beginTime:(CFTimeInterval)beginTime;

{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animation];
    //动画结束值
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(fromX,fromY,fromZ)];
                                
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(toX, toY, toZ)];
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
+ (CAAnimationGroup *)addAnimateGruopWithAnimations:(NSArray*)animations
                                           duration:(NSTimeInterval)duration;
{
    CAAnimationGroup *animateGroup = [CAAnimationGroup animation];
    animateGroup.animations = animations;
    animateGroup.duration = duration;
    animateGroup.removedOnCompletion = NO;
    animateGroup.fillMode = kCAFillModeForwards;
    return animateGroup;
}


+ (CAAnimationGroup *)alertContentAppearGruopAnimation
{

    CAAnimation *animation1 = [SLBasicAnimation createScaleAnimateDuration:0.2f timingFunction:nil fromX:0.3 fromY:0.3 fromZ:0.3 toX:1.1 toY:1.1 toZ:1.1 beginTime:0];
    
    CAAnimation *animation2 = [SLBasicAnimation createScaleAnimateDuration:0.1f timingFunction:nil fromX:1.1 fromY:1.1 fromZ:1.1 toX:1 toY:1 toZ:1 beginTime:0.2];
    
    CAAnimation *animtion3 = [SLBasicAnimation createOpacityAnimateDuration:.2f timingFunction:nil fromValue:0 toValue:1 beginTime:0];
    
    CAAnimationGroup *groupAnimation = [SLBasicAnimation addAnimateGruopWithAnimations:@[animation1,animation2,animtion3] duration:0.3f];
    
    return groupAnimation;

}

+ (CAAnimation *)alertMaskAppearAppearAnimation
{

    CAAnimation *animtion = [SLBasicAnimation createOpacityAnimateDuration:.3f timingFunction:nil fromValue:0 toValue:1 beginTime:0];
    
    return animtion;
    
}

+ (CAAnimationGroup *)alertContentDisAppearGroupAnimation
{

    CAAnimation *animation1 = [SLBasicAnimation createScaleAnimateDuration:0.2 timingFunction:nil fromX:1 fromY:1 fromZ:1 toX:.3 toY:.3 toZ:.3 beginTime:0];
    
    CAAnimation *animation2 = [SLBasicAnimation createOpacityAnimateDuration:0.15 timingFunction:nil fromValue:1 toValue:0 beginTime:0];
    
    CAAnimationGroup *groupAnimation = [SLBasicAnimation addAnimateGruopWithAnimations:@[animation1,animation2] duration:0.4f];
    
    return groupAnimation;

}

+ (CAAnimation *)alertMaskDisAppearAnimation
{

    CAAnimation *animation = [SLBasicAnimation createOpacityAnimateDuration:0.4 timingFunction:nil fromValue:1 toValue:0 beginTime:0];
    
    return animation;

}


@end
