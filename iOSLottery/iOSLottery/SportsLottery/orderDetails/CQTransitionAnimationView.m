//
//  CQTransitionAnimationView.m
//  caiqr
//
//  Created by 洪利 on 2017/4/17.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CQTransitionAnimationView.h"
#import "Masonry.h"
@implementation CQTransitionAnimationView

#pragma masonry 布局使用
+ (instancetype)creatTransitionAnimationView{
    CQTransitionAnimationView *view = [[CQTransitionAnimationView alloc] initWithFrame:CGRectZero];
    [view addSubViewS];
    return view;
}
- (void)addSubViewS{
    [self addSubview:self.bottomImageView];
    self.bottomImageView.userInteractionEnabled = YES;
    [self addSubview:self.topImageView];
    self.topImageView.userInteractionEnabled = YES;
    [self addSubview:self.clearBtn];
    [self addConstraint];
}
- (void)addConstraint{
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self);
    }];
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self);
    }];
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self);
    }];
}


- (void)btnSelected:(id)sender{
    if (self.btnclick) {
        self.btnclick();
    }
}

#pragma frame 布局使用
+ (instancetype)creatTransitionAnimationViewWithFrame:(CGRect)frame{
    CQTransitionAnimationView *view = [[CQTransitionAnimationView alloc] initWithFrame:frame];
    [view addSubview:view.bottomImageView];
    [view addSubview:view.topImageView];
    [view addSubview:view.clearBtn];
    view.topImageView.frame = view.bounds;
    view.bottomImageView.frame = view.bounds;
    view.clearBtn.frame = view.bounds;
    return view;
}



- (UIImageView *)topImageView{
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _topImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _topImageView;
}
    
    
- (UIImageView *)bottomImageView{
    if (!_bottomImageView) {
        _bottomImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bottomImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _bottomImageView;
}


- (UIButton *)clearBtn{
    if (!_clearBtn) {
        _clearBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_clearBtn addTarget:self action:@selector(btnSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearBtn;
}
@end
