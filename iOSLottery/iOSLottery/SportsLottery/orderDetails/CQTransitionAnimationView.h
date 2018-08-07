//
//  CQTransitionAnimationView.h
//  caiqr
//
//  Created by 洪利 on 2017/4/17.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CQTransition.h"
@interface CQTransitionAnimationView : UIView

+ (instancetype)creatTransitionAnimationViewWithFrame:(CGRect)frame;
+ (instancetype)creatTransitionAnimationView;

@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIImageView *bottomImageView;
@property (nonatomic, strong) UIButton *clearBtn;

@property (nonatomic, copy) void (^ btnclick)();

@end
