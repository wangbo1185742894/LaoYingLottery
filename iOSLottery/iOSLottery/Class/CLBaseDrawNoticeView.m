//
//  CLBaseDrawNoticeView.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/28.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLBaseDrawNoticeView.h"

#import "CLConfigMessage.h"

#import "CLAwardVoModel.h"

@implementation CLBaseDrawNoticeView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubviews];
        [self addConstraints];
    }
    return self;
}

- (void)addSubviews
{
    
    [self addSubview:self.lotteryNameLabel];
    [self addSubview:self.periodLabel];
    [self addSubview:self.timeLabel];
        
    [self addSubview:self.baseView];
}

- (void)addConstraints
{
    [self.lotteryNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(CL__SCALE(15.f));
        make.centerY.equalTo(self.periodLabel);
    }];
    
    [self.periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(CL__SCALE(17.f));
        make.left.equalTo(self.lotteryNameLabel.mas_right).offset(CL__SCALE(5.f));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.periodLabel.mas_right).offset(CL__SCALE(5.f));
        make.centerY.equalTo(self.periodLabel);
    }];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(CL__SCALE(15.f));
        make.top.equalTo(self.lotteryNameLabel.mas_bottom);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
}

- (void)setData:(CLAwardVoModel *)data
{
    
    self.lotteryNameLabel.text = data.gameName;
    self.timeLabel.text = data.awardTime;
    self.periodLabel.text = [NSString stringWithFormat:@"第%@期", data.periodId];
}

- (void)setShowLotteryName:(BOOL)show
{
    
    if (show == YES) return;
    
    self.lotteryNameLabel.hidden = YES;
    
    [self.periodLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self).offset(CL__SCALE(11.f));
    }];
    
    [self updateConstraintsIfNeeded];
}

- (void)setOnlyShowNumberText:(BOOL)show
{

    NSAssert(NO, @"子类需要重写该方法");
}

- (void)setShowInCenter:(BOOL)show
{
    
//    //默认是不居中显示
//    if (show == NO) return;
//
//
//    [self.baseView mas_remakeConstraints:^(MASConstraintMaker *make) {
//
//        make.centerX.equalTo(self);
//        make.top.equalTo(self).offset(CL__SCALE(53.f));
//        make.bottom.equalTo(self).offset(CL__SCALE(-18.f));
//    }];
//
//    [self updateConstraintsIfNeeded];
    NSAssert(NO, @"子类需要重写该方法");
}

#pragma mark ------- lazyLoad -------
- (UILabel *)lotteryNameLabel
{
    
    if (_lotteryNameLabel == nil) {
        
        _lotteryNameLabel = [self createLabelWithTextColor:UIColorFromRGB(0x333333) font:CL_FONT_SCALE(16.F)];
    }
    return _lotteryNameLabel;
    
}

- (UILabel *)periodLabel
{
    
    if (_periodLabel == nil) {
        
        _periodLabel = [self createLabelWithTextColor:UIColorFromRGB(0x9A9A9A) font:CL_FONT_SCALE(13.f)];
    }
    return _periodLabel;
}


- (UILabel *)timeLabel
{
    
    if (_timeLabel == nil) {
        
        _timeLabel = [self createLabelWithTextColor:UIColorFromRGB(0x9A9A9A) font:CL_FONT_SCALE(13.f)];
    }
    return _timeLabel;
    
}

- (UILabel *)createLabelWithTextColor:(UIColor *)textColor font:(UIFont *)font
{
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textColor = textColor;
    
    return label;
}


- (UIView *)baseView
{
    
    if (_baseView == nil) {
        
        _baseView = [[UIView alloc] initWithFrame:(CGRectZero)];
        
    }
    return _baseView;
}


@end
