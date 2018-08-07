//
//  CLLotteryOmissionView.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/17.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLLotteryOmissionView.h"
#import "CLConfigMessage.h"
#import "AppDelegate.h"
@interface CLLotteryOmissionView ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *subContentLable;
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UIButton *confirmBtn;

@end
@implementation CLLotteryOmissionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGBandAlpha(0x333333, 0.3);
        [self addSubview:self.baseView];
        [self.baseView addSubview:self.titleLabel];
        [self.baseView addSubview:self.topLineView];
        [self.baseView addSubview:self.contentLabel];
        [self.baseView addSubview:self.contentImageView];
        [self.baseView addSubview:self.subContentLable];
        [self.baseView addSubview:self.bottomLineView];
        [self.baseView addSubview:self.confirmBtn];
        [self configConstraint];
    }
    return self;
}
+ (void)showLotteryOmissionInWindowWithType:(CLOmissionPromptType)type{
    
    CLLotteryOmissionView *omissionView = [[CLLotteryOmissionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (type == CLOmissionPromptTypeKuaiSan) {
        omissionView.contentImageView.image = [UIImage imageNamed:@"FT_omissionAlert.png"];
    }else if (type == CLOmissionPromptTypeD11){
        omissionView.contentImageView.image = [UIImage imageNamed:@"Ball_omissionAlert.png"];
    }
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window addSubview:omissionView];
}
- (void)configConstraint{
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self);
        make.width.mas_equalTo(__SCALE(260.f));
//        make.height.mas_equalTo(__SCALE(190.f));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.baseView).offset(__SCALE(10.f));
        make.centerX.equalTo(self.baseView);
    }];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.baseView).offset(__SCALE(10.f));
        make.right.equalTo(self.baseView).offset(__SCALE(- 10.f));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(__SCALE(10));
        make.height.mas_equalTo(0.5f);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.topLineView).offset(__SCALE(5.f));
        make.right.equalTo(self.topLineView).offset(__SCALE(- 5.f));
        make.top.equalTo(self.topLineView).offset(__SCALE(10.f));
    }];
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentLabel).offset(__SCALE(10.));
        make.height.mas_equalTo(__SCALE(51.f));
        make.width.mas_equalTo(__SCALE(48.f));
        make.top.equalTo(self.contentLabel.mas_bottom).offset(__SCALE(10.f));
    }];
    
    [self.subContentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentImageView.mas_right).offset(__SCALE(- 3.f));
        make.centerY.equalTo(self.contentImageView.mas_top).offset(__SCALE(20.f));
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self);
        make.height.mas_equalTo(0.5f);
        make.top.equalTo(self.contentImageView.mas_bottom).offset(__SCALE(10.f));
    }];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.bottomLineView.mas_bottom);
        make.left.right.equalTo(self.baseView);
        make.height.mas_equalTo(__SCALE(40));
        make.bottom.equalTo(self.baseView);
    }];
}

#pragma mark ------------ event Response ------------
- (void)confirmOnClick:(UIButton *)btn{
    
    [self removeFromSuperview];
}

#pragma mark ------------ getter Mothed -----------
- (UIView *)baseView{
    
    if (!_baseView) {
        _baseView = [[UIView alloc] initWithFrame:CGRectZero];
        _baseView.backgroundColor = UIColorFromRGB(0xffffff);
        _baseView.layer.cornerRadius = 5.f;
        _baseView.layer.masksToBounds = YES;
    }
    return _baseView;
}
- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = UIColorFromRGB(0x333333);
        _titleLabel.text = @"遗漏是什么？";
        _titleLabel.font = FONT_BOLD(15);
    }
    return _titleLabel;
}
- (UIView *)topLineView{
    
    if (!_topLineView) {
        _topLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _topLineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    }
    return _topLineView;
}
- (UILabel *)contentLabel{
    
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.textColor = UIColorFromRGB(0x333333);
        _contentLabel.text = @"号码下方的数字指该号码自上次开出以来至本次未开出的期数。";
        _contentLabel.font = FONT_SCALE(15);
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
- (UILabel *)subContentLable{
    
    if (!_subContentLable) {
        _subContentLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _subContentLable.textColor = UIColorFromRGB(0x333333);
        _subContentLable.text = @"号码5已经有6期未开出了";
        _subContentLable.font = FONT_SCALE(15);
        _subContentLable.numberOfLines = 0;
    }
    return _subContentLable;
}
- (UIImageView *)contentImageView{
    
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
        _contentImageView.image = [UIImage imageNamed:@"FT_omissionAlert.png"];
    }
    return _contentImageView;
}
- (UIView *)bottomLineView{
    
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    }
    return _bottomLineView;
}
- (UIButton *)confirmBtn{
    
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_confirmBtn setTitle:@"我知道了" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:LINK_COLOR forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = FONT_SCALE(17);
        [_confirmBtn addTarget:self action:@selector(confirmOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}
@end
