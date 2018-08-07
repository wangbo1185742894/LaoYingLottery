//
//  CLNavigationView.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLNavigationView.h"
#import "CLConfigMessage.h"
#import "CQDefinition.h"
#import "Masonry.h"
@interface CLNavigationView ()

@property (nonatomic, strong) UIButton *backButton;//返回按钮

@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIImageView *rightImageView;//右侧图片
@property (nonatomic, strong) UILabel *rightTitleLabel;//右侧文字

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;//中间的文字
@property (nonatomic, strong) UIImageView *midImageView;//图片

@end
@implementation CLNavigationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        self.backgroundColor = THEME_COLOR;
        
        [self addSubview:self.backButton];
        [self addSubview:self.rightView];
        [self.rightView addSubview:self.rightTitleLabel];
        [self.rightView addSubview:self.rightImageView];
        [self addSubview:self.titleView];
        [self.titleView addSubview:self.titleLabel];
        [self.titleView addSubview:self.midImageView];
        [self configSubConstraint];
        
        UITapGestureRecognizer *tapTitleView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTitleView:)];
        [self.titleView addGestureRecognizer:tapTitleView];
        UITapGestureRecognizer *tapRightView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRightView:)];
        [self.rightView addGestureRecognizer:tapRightView];
    }
    return self;
}
#pragma mark - 点击了titleView
- (void)tapTitleView:(UITapGestureRecognizer *)tap{
    
    self.titleViewBlock ? self.titleViewBlock() : nil;
}
- (void)tapRightView:(UITapGestureRecognizer *)tap{
    
    self.rightViewBlock ? self.rightViewBlock() : nil;
}
- (void)btnOnClick:(UIButton *)btn{
    
    self.leftViewBlock ? self.leftViewBlock() : nil;
}
#pragma mark ------ 配置约束 ------
- (void)configSubConstraint{
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self.titleView);
        make.width.mas_equalTo(__SCALE(30.f));
        make.height.mas_equalTo(__SCALE(30.f));
    }];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(__SCALE(- 10));
        make.centerY.equalTo(self.titleView);
    }];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self.rightView);
        make.width.mas_equalTo(__SCALE(10));
        make.height.mas_equalTo(__SCALE(13.f));
    }];
    [self.rightTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightImageView.mas_right).offset(__SCALE(5.f));
        make.top.bottom.right.equalTo(self.rightView);
    }];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-8);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleView).offset(10.f);
        make.top.equalTo(self.titleView).offset(5.f);
        make.bottom.equalTo(self.titleView).offset(-5.f);
    }];
    [self.midImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(3.f);
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.titleView).offset(-10.f);
    }];
}

#pragma mark - 向下箭头的旋转
- (void)midImageViewIsRotation:(BOOL)isRotation{
    
    
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    if (isRotation) {
        animation.fromValue = [NSNumber numberWithFloat:0.f];
        animation.toValue =  [NSNumber numberWithFloat: M_PI];
    }else{
        animation.fromValue = [NSNumber numberWithFloat:M_PI];
        animation.toValue =  [NSNumber numberWithFloat: M_PI * 2];
    }
    animation.duration  = .5f;
    animation.repeatCount = 1;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [self.midImageView.layer addAnimation:animation forKey:nil];
    
}

- (void)setShowMidImage:(BOOL)show
{

    if (show == YES) return;
    
    self.midImageView.hidden = YES;
    
    [self.midImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.titleLabel.mas_right);
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.titleView).offset(-10.f);
        make.width.mas_equalTo(0);

    }];
}

- (void)setShowRightBtn:(BOOL)show{
    if (show == YES) return;
    self.rightView.hidden = YES;
}

#pragma mark ------ setter Mothed ------
- (void)setNavigationTitle:(NSString *)navigationTitle{
    
    self.titleLabel.text = navigationTitle;
}
#pragma mark ------ getter Mothed ------


- (UIButton *)backButton{
    
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_backButton setImage:[UIImage imageNamed:@"allBack.png"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
- (UIView *)rightView
{
    if (!_rightView) {
        _rightView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _rightView;
}
- (UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _titleView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.text = @"和值";
        _titleLabel.textColor = UIColorFromRGB(0xffffff);
        _titleLabel.font = FONT_SCALE(17.f);
    }
    return _titleLabel;
}
- (UIImageView *)midImageView
{
    if (!_midImageView) {
        _midImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _midImageView.contentMode = UIViewContentModeScaleAspectFit;
        _midImageView.image = [UIImage imageNamed:@"lotteryPlayMothedPullDown.png"];
    }
    return _midImageView;
}
- (UIImageView *)rightImageView{
    
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _rightImageView.image = [UIImage imageNamed:@"lotteryHelperImage.png"];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _rightImageView;
}
- (UILabel *)rightTitleLabel{
    
    if (!_rightTitleLabel) {
        _rightTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _rightTitleLabel.text = @"助手";
        _rightTitleLabel.textColor = UIColorFromRGB(0xffffff);
        _rightTitleLabel.font = FONT_SCALE(15);
    }
    return _rightTitleLabel;
}
@end
