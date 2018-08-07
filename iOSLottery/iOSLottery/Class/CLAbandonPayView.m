//
//  CLAbandonPayView.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/5.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLAbandonPayView.h"
#import "CLConfigMessage.h"
#import "Masonry.h"
@interface CLAbandonPayView ()

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *abandonButton;
@property (nonatomic, strong) UIButton *continuePayButton;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation CLAbandonPayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGBandAlpha(0x000000, .75);
        [self addSubview:self.mainView];
        [self.mainView addSubview:self.titleLabel];
        [self.mainView addSubview:self.contentLabel];
        [self.mainView addSubview:self.abandonButton];
        [self.mainView addSubview:self.continuePayButton];
        [self.mainView addSubview:self.lineView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnClick:)];
        [self addGestureRecognizer:tap];
        
        [self configConstraint];
        
    }
    return self;
}
#pragma mark ---------event Response
- (void)abandonButtonOnClick:(UIButton *)btn{
//    NSLog(@"点击了放弃按钮");
    if (self.abandonBlock) {
        self.abandonBlock(self);
    }
}
- (void)continuePayButtonOnClick:(UIButton *)btn{
//    NSLog(@"点击了继续支付按钮");
    if (self.continueButtonBlock) {
        self.continueButtonBlock(self);
    }
}
- (void)tapOnClick:(UITapGestureRecognizer *)tap{
//    NSLog(@"点了自身");
    if (self.tapSelfBlock) {
        self.tapSelfBlock(self);
    }
}

#pragma mark --------- privateMothed --------
#pragma mark - 配置约束
- (void)configConstraint{
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(__SCALE(230));
        make.height.mas_equalTo(__SCALE(120));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mainView).offset(__SCALE(20.f));
        make.centerX.equalTo(self.mainView);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleLabel.mas_bottom).offset(__SCALE(5.f));
        make.centerX.equalTo(self.titleLabel);
    }];
    [self.abandonButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mainView);
        make.left.equalTo(self.mainView);
        make.width.equalTo(self.mainView).multipliedBy(.5);
        make.height.mas_equalTo(__SCALE(35));
    }];
    [self.continuePayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mainView);
        make.left.equalTo(self.abandonButton.mas_right);
        make.width.equalTo(self.mainView).multipliedBy(.5);
        make.height.equalTo(self.abandonButton);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.abandonButton);
        make.top.equalTo(self.abandonButton);
        make.height.mas_equalTo(.5);
        make.width.equalTo(self.abandonButton);
    }];
    
}
#pragma mark --------- setterMothed --------
- (void)setTitleString:(NSString *)titleString{
    
    self.titleLabel.text = titleString;
    
}
- (void)setContentString:(NSString *)contentString{
    
    self.contentLabel.text = contentString;
    
}
- (void)setOkBtnTitle:(NSString *)okBtnTitle{
    
    [self.continuePayButton setTitle:okBtnTitle forState:UIControlStateNormal];
    
}
- (void)setCancelBtnTitel:(NSString *)cancelBtnTitel{
    
    [self.abandonButton setTitle:cancelBtnTitel forState:UIControlStateNormal];
    
}

#pragma mark --------- getterMothed --------
- (UIView *)mainView{
    if (!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:CGRectZero];
        _mainView.backgroundColor = UIColorFromRGB(0xffffff);
        _mainView.layer.cornerRadius = 2.f;
    }
    return _mainView;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    }
    return _lineView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = UIColorFromRGB(0x333333);
        _titleLabel.font = FONT_SCALE(16);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"距离奖金到手只有一步之遥";
    }
    return _titleLabel;
}
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.textColor = UIColorFromRGB(0x333333);
        _contentLabel.font = FONT_SCALE(16);
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.text = @"确定要放弃吗？";
    }
    
    return _contentLabel;
}
- (UIButton *)abandonButton{
    if (!_abandonButton) {
        _abandonButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_abandonButton setTitle:@"放弃" forState:UIControlStateNormal];
        if (self.cancelBtnTitel) {
            [_abandonButton setTitle:self.cancelBtnTitel forState:UIControlStateNormal];
        }
        [_abandonButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        _abandonButton.titleLabel.font = FONT_SCALE(14.f);
        [_abandonButton addTarget:self action:@selector(abandonButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _abandonButton;
}
- (UIButton *)continuePayButton{
    if (!_continuePayButton) {
        _continuePayButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _continuePayButton.backgroundColor = UIColorFromRGB(0xff4747);
        [_continuePayButton setTitle:@"继续支付" forState:UIControlStateNormal];
        if (self.okBtnTitle) {
            [_abandonButton setTitle:self.okBtnTitle forState:UIControlStateNormal];
        }
        [_continuePayButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _continuePayButton.titleLabel.font = FONT_SCALE(14.f);
        [_continuePayButton addTarget:self action:@selector(continuePayButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _continuePayButton;
}

@end
