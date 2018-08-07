//
//  SLEndBetAlertView.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/1.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLEndBetAlertView.h"

#import "SLConfigMessage.h"
#import "UILabel+SLAttributeLabel.h"
#import "CLConfigMessage.h"
@interface SLEndBetAlertView ()

@property (nonatomic, strong) UIView *baseView;
/**
 标题label
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 内容label
 */
@property (nonatomic, strong) UILabel *desLabel;

/**
 取消button
 */
@property (nonatomic, strong) UIButton *cancelButton;

/**
 跳转button
 */
@property (nonatomic, strong) UIButton *jumpButton;
@end

@implementation SLEndBetAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = SL_UIColorFromRGBandAlpha(0x333333, 0.75);
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
        
        make.left.equalTo(self).offset(SL__SCALE(35.f));
        make.right.equalTo(self).offset(SL__SCALE(- 35.f));
        //make.top.equalTo(self).offset(SL__SCALE(215.f));
        make.centerY.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.baseView);
        make.centerX.equalTo(self.baseView);
        make.height.mas_equalTo(SL__SCALE(60.f));
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.baseView).offset(SL__SCALE(15.f));
        make.right.equalTo(self.baseView).offset(SL__SCALE(- 15.f));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(SL__SCALE(33.f));
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.baseView).offset(SL__SCALE(10.f));
        make.top.equalTo(self.desLabel.mas_bottom).offset(SL__SCALE(33.f));
        make.height.mas_equalTo(SL__SCALE(35.f));
        make.bottom.equalTo(self.baseView).offset(SL__SCALE(-10.f));
    }];
    
    [self.jumpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.cancelButton.mas_right).offset(SL__SCALE(10.f));
        make.width.height.top.equalTo(self.cancelButton);
        make.right.equalTo(self.baseView).offset(SL__SCALE(-10.f));
        //make.top.equalTo(self.cancelButton);
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
- (void)setType:(SLEndBetGuideType)type{
    
    if (type == SLEndBetGuideTypeEnd) {
        
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(60);
        }];
    }else if (SLEndBetGuideTypeNoSale){
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(__SCALE(0.f));
        }];
    }
    
}

- (void)setTitle:(NSString *)title{
    
    self.titleLabel.text = title;
}

- (void)setDesText:(NSString *)desText{
    
    [self.desLabel sl_attributeWithText:desText beginTag:@"^" endTag:@"&" color:THEME_COLOR];
}
- (void)setJumpButtonTitle:(NSString *)jumpButtonTitle{
    
    [self.jumpButton setTitle:jumpButtonTitle forState:UIControlStateNormal];
}

#pragma mark ------------ getter Mothed ------------
- (UIView *)baseView{
    
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = UIColorFromRGB(0xffffff);
        _baseView.layer.cornerRadius = 6.f;
    }
    return _baseView;
}

- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"本期已截止";
        _titleLabel.textColor = SL_UIColorFromRGB(0x333333);
        _titleLabel.font = SL_FONT_BOLD(17.f);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UILabel *)desLabel{
    
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.text = @"";
        _desLabel.numberOfLines = 0;
        _desLabel.textColor = SL_UIColorFromRGB(0x333333);
        _desLabel.font = SL_FONT_SCALE(17.f);
        _desLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _desLabel;
}
- (UIButton *)cancelButton{
    
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = SL_FONT_SCALE(15.f);
        _cancelButton.layer.borderColor = SL_UIColorFromRGB(0xece5dd).CGColor;
        _cancelButton.layer.borderWidth = 0.5f;
        _cancelButton.layer.cornerRadius = 4.f;
        [_cancelButton setTitleColor:SL_UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)jumpButton{
    
    if (!_jumpButton) {
        _jumpButton = [[UIButton alloc] init];
        [_jumpButton setTitle:@"跳转" forState:UIControlStateNormal];
        _jumpButton.titleLabel.font = SL_FONT_SCALE(15.f);
        _jumpButton.layer.borderColor = SL_UIColorFromRGB(0x999999).CGColor;
//        _jumpButton.layer.borderWidth = 0.5f;
        _jumpButton.layer.cornerRadius = 4.f;
        _jumpButton.backgroundColor = THEME_COLOR;
        [_jumpButton setTitleColor:SL_UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_jumpButton addTarget:self action:@selector(jumpButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _jumpButton;
}

@end

