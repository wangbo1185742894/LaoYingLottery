//
//  CKRechargeHintView.m
//  caiqr
//
//  Created by 任鹏杰 on 2017/5/3.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKRechargeHintView.h"
#import "Masonry.h"
#import "CKDefinition.h"

@interface CKRechargeHintView ()

@property (nonatomic, strong) UIView *contextView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIView *markView;

@end


@implementation CKRechargeHintView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubviews];
        [self addConstraints];
        self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
        
    }
    
    return self;
}

- (void)addSubviews
{
    
    [self addSubview:self.contextView];
    [self addSubview:self.cancelBtn];
    [self.contextView addSubview:self.titleLabel];
    [self.contextView addSubview:self.recommendBtn];
}

- (void)addConstraints
{
    [self.contextView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(__SCALE(230));
        make.height.mas_equalTo(__SCALE(115));
        
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contextView.mas_left);
        make.top.equalTo(self.contextView.mas_top).offset(__SCALE(26));
        make.right.equalTo(self.contextView.mas_right);
        
    }];
    
    [self.recommendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //make.top.equalTo(self.titleLabel.mas_bottom).offset(__SCALE(40));
        make.left.equalTo(self.contextView.mas_left).offset(__SCALE(15));
        make.right.equalTo(self.contextView.mas_right).offset(__SCALE(-15));
        make.bottom.equalTo(self.contextView.mas_bottom).offset(__SCALE(-15));
        make.height.mas_equalTo(__SCALE(30));
        
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contextView.mas_right);
        make.bottom.equalTo(self.contextView.mas_top).offset(__SCALE(-10));
    }];
    
}

- (void)showTitleText:(NSString *)text buttonTitle:(NSString *)buttonTitile
{

    self.titleLabel.text = text;
    [self.recommendBtn setTitle:buttonTitile forState:(UIControlStateNormal)];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}


#pragma mark --- buttonClick ---
- (void)cancelBtnClick
{
    
    [self removeFromSuperview];
    
}


#pragma mark --- Get Method ---
- (UIView *)contextView
{
    
    if (_contextView == nil) {
        
        _contextView = [[UIView alloc] init];
        _contextView.backgroundColor = [UIColor whiteColor];
        _contextView.layer.masksToBounds = YES;
        _contextView.layer.cornerRadius = 2;
    }
    return _contextView;
}

- (UILabel *)titleLabel
{
    
    if (_titleLabel == nil) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = FONT_SCALE(15.f);
    }
    
    return _titleLabel;
    
}

- (UIButton *)cancelBtn
{
    
    if (_cancelBtn == nil) {
        
        _cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        _cancelBtn.backgroundColor = [UIColor clearColor];
        [_cancelBtn setImage:[UIImage imageNamed:@"CKRechargeCancel"] forState:(UIControlStateNormal)];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _cancelBtn;
    
}

- (UIButton *)recommendBtn
{
    
    if (_recommendBtn == nil) {
        
        _recommendBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_recommendBtn setTitleColor:UIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
        [_recommendBtn setBackgroundColor:UIColorFromRGB(0x5797FC)];
        _recommendBtn.titleLabel.font = FONT_SCALE(15.f);
        _recommendBtn.layer.masksToBounds = YES;
        _recommendBtn.layer.cornerRadius = 2;
    }
    
    return _recommendBtn;
}


@end
