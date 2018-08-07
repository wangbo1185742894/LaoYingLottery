//
//  CQBasicAnimation.h
//  caiqr
//
//  Created by huangyuchen on 16/8/11.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CQBasicAnimation : NSObject
//添加位移动画
+ (CAAnimation*)createPositionAnimateDuration:(NSTimeInterval)duration
                                positionValus:(NSArray*)valus
                              timingFunctions:(NSArray*)timingFunctions
                                    beginTime:(CFTimeInterval)beginTime;
//添加透明动画
+ (CAAnimation*)createOpacityAnimateDuration:(NSTimeInterval)duration
                              timingFunction:(CAMediaTimingFunction*)timingFunction
                                   fromValue:(CGFloat)fromValue
                                     toValue:(CGFloat)toValue
                                   beginTime:(CFTimeInterval)beginTime;
//添加形变动画
+ (CAAnimation*)createScaleAnimateDuration:(NSTimeInterval)duration
                            timingFunction:(CAMediaTimingFunction*)timingFunction
                                        sx:(CGFloat)x
                                        sy:(CGFloat)y
                                        sy:(CGFloat)z
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
+ (CAAnimationGroup *)addAnimateGruopToLayer:(CALayer*)layer
                                  animations:(NSArray*)animations
                                    duration:(NSTimeInterval)duration;
@end
