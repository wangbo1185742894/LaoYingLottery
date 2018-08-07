//
//  CLATDrawNoticView.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLATDrawNoticeView.h"

#import "CLConfigMessage.h"

#import "CLAwardNumberView.h"

#import "CLAwardVoModel.h"

@interface CLATDrawNoticeView ()

/**
 彩种名
 */
@property (nonatomic, strong) UILabel* lotteryNameLabel;

/**
 期次
 */
@property (nonatomic, strong) UILabel *periodLabel;

/**
 开奖日期
 */
@property (nonatomic, strong) UILabel* timeLabel;

/**
 试机号
 */
@property (nonatomic, strong) UILabel *testLabel;

@property (nonatomic, strong) CLAwardNumberView *redNumbers;

@property (nonatomic, strong) UIView *baseView;


@end

@implementation CLATDrawNoticeView

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self p_addSubviews];
        [self p_addConstraints];
    }
    return self;
}

- (void)p_addSubviews
{
    
    [self addSubview:self.lotteryNameLabel];
    [self addSubview:self.periodLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.testLabel];
    
    [self.baseView addSubview:self.redNumbers];
    [self.baseView addSubview:self.testLabel];
    
    [self addSubview:self.baseView];
}

- (void)p_addConstraints
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
       
        make.left.equalTo(self).offset(CL__SCALE(10.f));
        make.top.equalTo(self).offset(CL__SCALE(53.f));
        make.bottom.equalTo(self).offset(CL__SCALE(-18.f));
    }];
    
    [self.redNumbers mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.baseView);
        make.height.mas_equalTo(CL__SCALE(35.f));
    }];
    
    [self.testLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.redNumbers.mas_right).offset(CL__SCALE(10.f));
        make.centerY.equalTo(self.redNumbers);
        make.right.equalTo(self.baseView);
    }];
    
}

- (void)setData:(CLAwardVoModel *)data
{
    
    self.lotteryNameLabel.text = data.gameName;
    self.timeLabel.text = data.awardTime;
    self.periodLabel.text = [NSString stringWithFormat:@"第%@期", data.periodId];
    
    NSString *string = [data.winningNumbers stringByReplacingOccurrencesOfString:@":" withString:@" "];
    self.redNumbers.numbers = [string componentsSeparatedByString:@" "];
    
    self.testLabel.text = [NSString stringWithFormat:@"试机号：%@",data.testNum];
    
    if ([data.gameEn isEqualToString:@"fc3d"]) {
        
        self.testLabel.hidden = NO;
        
//        [self.testLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//           
//            make.width.mas_equalTo(CL__SCALE(88.f));
//            
//        }];
        
    }else{
    
        self.testLabel.hidden = YES;
        
        [self.testLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(0);
            
        }];
    }
    
    [self updateConstraintsIfNeeded];
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
    [self.redNumbers setOnlyShowText:show];
}

- (void)setShowInCenter:(BOOL)show
{

    //默认是不居中显示
    if (show == NO) return;
    
    
    [self.baseView mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(CL__SCALE(53.f));
        make.bottom.equalTo(self).offset(CL__SCALE(-18.f));
    }];
    
    [self updateConstraintsIfNeeded];

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

- (UILabel *)testLabel
{

    if (_testLabel == nil) {
        
        _testLabel = [self createLabelWithTextColor:UIColorFromRGB(0x333333) font:CL_FONT_SCALE(15.f)];
    }
    return _testLabel;
}

- (UILabel *)createLabelWithTextColor:(UIColor *)textColor font:(UIFont *)font
{
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textColor = textColor;
    
    return label;
}

- (CLAwardNumberView *)redNumbers
{
    if (_redNumbers == nil) {
        
        _redNumbers =[[CLAwardNumberView alloc] init];
        _redNumbers.ballColor = THEME_COLOR;
        _redNumbers.space = CL__SCALE(5.f);
        _redNumbers.ballWidthHeight = CL__SCALE(35.f);
        
        _redNumbers.showTwoPlaces = NO;
        
    }
    return _redNumbers;
}

- (UIView *)baseView
{

    if (_baseView == nil) {
        
        _baseView = [[UIView alloc] initWithFrame:(CGRectZero)];
        
    }
    return _baseView;
}

@end
