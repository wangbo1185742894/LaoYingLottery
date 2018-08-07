//
//  SLBetDetailsFooterView.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/17.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLBetDetailsFooterView.h"
#import "SLConfigMessage.h"

@interface SLBetDetailsFooterView ()

/**
 顶部票边图片
 */
@property (nonatomic, strong) UIImageView *topImage;

/**
 勾选图片
 */
@property (nonatomic, strong) UIImageView *checkImage;

/**
 正常文字label
 */
@property (nonatomic, strong) UILabel *normalLabel;

/**
 富文本文字label
 */
@property (nonatomic, strong) UIButton *attrButton;

/**
 内容View
 */
@property (nonatomic, strong) UIView *contentView;

@end

@implementation SLBetDetailsFooterView

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubviews];
        [self addConstraints];
        
        self.backgroundColor = SL_UIColorFromRGB(0xfaf8f6);
    }

    return self;
}

- (void)attrButtonOnClick:(UIButton *)btn{
    
    !self.entrustBlock ? : self.entrustBlock();
}

- (void)addSubviews
{
    [self.contentView addSubview:self.topImage];
    [self.contentView addSubview:self.checkImage];
    [self.contentView addSubview:self.normalLabel];
    [self.contentView addSubview:self.attrButton];
    
    [self addSubview:self.contentView];
}

- (void)addConstraints
{
    [self.topImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(SL__SCALE(8.f));
    }];

    [self.checkImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(self.contentView);
        make.width.height.mas_equalTo(SL__SCALE(10.f));
    }];
    
    [self.normalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.checkImage.mas_right).offset(SL__SCALE(2.f));
        make.centerY.equalTo(self.checkImage.mas_centerY);
        
    }];
    
    [self.attrButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.normalLabel.mas_right).offset(SL__SCALE(2.f));
        make.centerY.equalTo(self.checkImage.mas_centerY);
        make.right.equalTo(self.contentView.mas_right);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.topImage.mas_bottom).offset(SL__SCALE(10.f));
        make.centerX.equalTo(self.mas_centerX);
        make.height.mas_equalTo(SL__SCALE(10.f));
        //make.bottom.equalTo(self.mas_bottom).offset(SL__SCALE(-5.f));
    }];
}

#pragma mark --- Get Method ---

- (UIImageView *)topImage
{

    if (_topImage == nil) {
        
        _topImage = [[UIImageView alloc] initWithFrame:(CGRectZero)];
        _topImage.image = [UIImage imageNamed:@"bet_details_ticket_side"];
    }

    return _topImage;
}

- (UIImageView *)checkImage
{

    if (_checkImage == nil) {
        
        _checkImage = [[UIImageView alloc] initWithFrame:(CGRectZero)];
        _checkImage.image = [UIImage imageNamed:@"bet_details_check"];
    }

    return _checkImage;
}

- (UILabel *)normalLabel
{

    if (_normalLabel == nil) {
        
        _normalLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _normalLabel.text = @"我已阅读并同意";
        _normalLabel.textColor = SL_UIColorFromRGB(0x333333);
        _normalLabel.font = SL_FONT_SCALE(10.f);
    }
    
    return _normalLabel;
}

- (UIButton *)attrButton
{
    if (_attrButton == nil) {
        
        _attrButton = [[UIButton alloc] initWithFrame:(CGRectZero)];
        
        [_attrButton setTitle:@"《委托投注协议》" forState:UIControlStateNormal];
        
        _attrButton.titleLabel.font = SL_FONT_SCALE(10.f);
        
        [_attrButton setTitleColor:SL_UIColorFromRGB(0x5494ff) forState:UIControlStateNormal];
        
        [_attrButton addTarget:self action:@selector(attrButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _attrButton;

}

- (UIView *)contentView
{

    if (_contentView == nil) {
        
        _contentView = [[UIView alloc] initWithFrame:(CGRectZero)];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

@end
