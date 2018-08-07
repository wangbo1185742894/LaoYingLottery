//
//  SLBasicAnimation.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/6/14.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SLBasicAnimation : NSObject

//添加位移动画
+ (CAAnimation*)createPositionAnimateDuration:(NSTimeInterval)duration
                                positionValus:(NSArray*)valus
                              timingFunctions:(NSArray*)timingFunctions
                                    beginTime:(CFTimeInterval)beginTime;
/**
 添加透明动画
 */
+ (CAAnimation*)createOpacityAnimateDuration:(NSTimeInterval)duration
                              timingFunction:(CAMediaTimingFunction*)timingFunction
                                   fromValue:(CGFloat)fromValue
                                     toValue:(CGFloat)toValue
                                   beginTime:(CFTimeInterval)beginTime;
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
//添加旋转动画
+ (CAAnimation*)createRotationAnimateDuration:(NSTimeInterval)duration
                               timingFunction:(CAMediaTimingFunction*)timingFunction
                                        angle:(CGFloat)angle
                                            x:(CGFloat)x
                                            y:(CGFloat)y
                                            z:(CGFloat)z
                                  repeatCount:(NSInteger)count
                                    beginTime:(CFTimeInterval)beginTime;

//添加组动画
+ (CAAnimationGroup *)addAnimateGruopWithAnimations:(NSArray*)animations
                                           duration:(NSTimeInterval)duration;



+ (CAAnimationGroup *)alertContentAppearGruopAnimation;

+ (CAAnimation *)alertMaskAppearAppearAnimation;

+ (CAAnimationGroup *)alertContentDisAppearGroupAnimation;

+ (CAAnimation *)alertMaskDisAppearAnimation;

@end
