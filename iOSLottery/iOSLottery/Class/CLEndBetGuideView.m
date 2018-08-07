//
//  CLEndBetGuideView.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/5/26.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLEndBetGuideView.h"
#import "CLConfigMessage.h"
#import "UILabel+CLAttributeLabel.h"
@interface CLEndBetGuideView ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UILabel *titleLabel;//标题label
@property (nonatomic, strong) UILabel *desLabel;//内容label
@property (nonatomic, strong) UIButton *cancelButton;//取消button
@property (nonatomic, strong) UIButton *jumpButton;//跳转button

@end

@implementation CLEndBetGuideView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGBandAlpha(0x333333, 0.75);
        [self addSubview:self.baseView];
        [self.baseView addSubview:self.titleLabel];
        [self.baseView addSubview:self.desLabel];
        [self.baseView addSubview:self.cancelButton];
        [self.baseView addSubview:self.jumpButton];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSlef)];
        [self addGestureRecognizer:tap];
        
        [self configConstrait];
    }
    return self;
}
- (void)configConstrait{
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(__SCALE(30.f));
        make.right.equalTo(self).offset(__SCALE(- 30.f));
        make.top.equalTo(self).offset(__SCALE(215.f));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.baseView);
        make.centerX.equalTo(self.baseView);
        make.height.mas_equalTo(__SCALE(60.f));
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.baseView).offset(__SCALE(20.f));
        make.right.equalTo(self.baseView).offset(__SCALE(- 20.f));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(__SCALE(20.f));
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.baseView).offset(__SCALE(20.f));
        make.top.equalTo(self.desLabel.mas_bottom).offset(__SCALE(20.f));
        make.height.mas_equalTo(__SCALE(30.f));
        make.bottom.equalTo(self.baseView).offset(__SCALE(-20.f));
    }];
    
    [self.jumpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.cancelButton.mas_right).offset(__SCALE(10.f));
        make.width.height.equalTo(self.cancelButton);
        make.right.equalTo(self.baseView).offset(__SCALE(-20.f));
        make.top.equalTo(self.cancelButton);
    }];
}

#pragma mark ------------ event Response ------------
- (void)cancelButtonOnClick:(UIButton *)btn
{
    
    [self tapSlef];
}
- (void)jumpButtonOnClick:(UIButton *)btn
{
    !self.jumpLotteryBlock ? : self.jumpLotteryBlock();
    [self tapSlef];
}

- (void)tapSlef{
    
    [self removeFromSuperview];
}

#pragma mark ------------ setter Mothed ------------
- (void)setType:(CLEndBetGuideType)type{
    
    if (type == CLEndBetGuideTypeEnd) {
        
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(60);
        }];
    }else if (CLEndBetGuideTypeNoSale){
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(__SCALE(0.f));
        }];
    }
    
}

- (void)setTitle:(NSString *)title{
    
    self.titleLabel.text = title;
}

- (void)setDesText:(NSString *)desText{
    
    [self.desLabel attributeWithText:desText beginTag:@"^" endTag:@"&" color:THEME_COLOR];
}
- (void)setJumpButtonTitle:(NSString *)jumpButtonTitle{
    
    [self.jumpButton setTitle:jumpButtonTitle forState:UIControlStateNormal];
}

#pragma mark ------------ getter Mothed ------------
- (UIView *)baseView{
    
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = UIColorFromRGB(0xffffff);
        _baseView.layer.cornerRadius = 10.f;
    }
    return _baseView;
}

- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"本期已截止";
        _titleLabel.textColor = UIColorFromRGB(0x333333);
        _titleLabel.font = FONT_BOLD(17.f);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UILabel *)desLabel{
    
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.text = @"";
        _desLabel.numberOfLines = 0;
        _desLabel.textColor = UIColorFromRGB(0x333333);
        _desLabel.font = FONT_SCALE(15.f);
        _desLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _desLabel;
}
- (UIButton *)cancelButton{
    
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = FONT_SCALE(17.f);
        _cancelButton.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
        _cancelButton.layer.borderWidth = 0.5f;
        _cancelButton.layer.cornerRadius = 2.f;
        [_cancelButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)jumpButton{
    
    if (!_jumpButton) {
        _jumpButton = [[UIButton alloc] init];
        [_jumpButton setTitle:@"跳转" forState:UIControlStateNormal];
        _jumpButton.titleLabel.font = FONT_SCALE(17.f);
        _jumpButton.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
        _jumpButton.layer.borderWidth = 0.5f;
        _jumpButton.layer.cornerRadius = 2.f;
        _jumpButton.backgroundColor = THEME_COLOR;
        [_jumpButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_jumpButton addTarget:self action:@selector(jumpButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _jumpButton;
}

@end
