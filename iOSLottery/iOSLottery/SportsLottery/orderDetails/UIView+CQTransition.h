//
//  UIControl+CQTransition.h
//  caiqr
//
//  Created by 洪利 on 2017/4/14.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CQTransitionAnimationType) {
    CQTransitionAnimationTypeTwinkle = 0,
    CQTransitionAnimationTypeTransition = 1
};

@interface UIView (CQTransition)

- (void)startAnimationWithTransitionWithStyle:(CQTransitionAnimationType)type;
- (void)stopAllAnimation;
@end
