//
//  CLAwardD11View.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLAwardD11View.h"
#import "CLAwardNumberView.h"
#import "CLConfigMessage.h"

@interface CLAwardD11View ()


@property (nonatomic, strong) CLAwardNumberView* d11View;

@end


@implementation CLAwardD11View

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubviews];
        [self addConstraints];
        
        self.isCenter = NO;
    }
    return self;
}

- (void)addSubviews
{
    [self addSubview:self.ShapeLabel];
    [self addSubview:self.lotteryNameLbl];
    [self addSubview:self.timeLbl];
    [self addSubview:self.d11View];
    [self addSubview:self.periodLabel];
    
}

- (void)addConstraints
{

    [self.lotteryNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(CL__SCALE(15.f));
        make.bottom.equalTo(self.periodLabel);
        make.height.mas_equalTo(CL__SCALE(35));
    }];
    
    [self.periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.lotteryNameLbl.mas_right).offset(CL__SCALE(5.f));
        make.centerY.equalTo(self.mas_bottom).multipliedBy(.26f);
        make.height.equalTo(self.lotteryNameLbl);
    }];
    
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.periodLabel.mas_right).offset(CL__SCALE(5.f));
        make.bottom.equalTo(self.periodLabel);
        make.height.equalTo(self.lotteryNameLbl);
    }];
    
    [self.d11View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lotteryNameLbl);
        make.height.equalTo(self).multipliedBy(.33f);
        make.bottom.equalTo(self.mas_bottom).offset(CL__SCALE(- 15.f));
    }];
    
    [self.ShapeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.d11View.mas_right).offset(CL__SCALE(5.f));
        make.centerY.equalTo(self.d11View);
    }];
    
}
- (void)setIsShowLotteryName:(BOOL)isShowLotteryName {
    
    self.lotteryNameLbl.hidden = !isShowLotteryName;
    if (isShowLotteryName) {
        [self.lotteryNameLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(CL__SCALE(10));
            make.bottom.equalTo(self.periodLabel);
            make.height.mas_equalTo(CL__SCALE(30));
        }];
    }else{
        [self.lotteryNameLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(CL__SCALE(10));
            make.centerY.equalTo(self.mas_bottom).multipliedBy(.25f);
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(CL__SCALE(30));
        }];
    }
    
    
    [self updateConstraints];
}

- (void)setIsCenter:(BOOL)isCenter{
    
    if (isCenter) {
        [self.d11View mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self);
            make.height.equalTo(self).multipliedBy(.33f);
            make.bottom.equalTo(self.mas_bottom).offset(CL__SCALE(- 15.f));
        }];
    }else{
        
        [self.d11View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lotteryNameLbl);
            make.height.equalTo(self).multipliedBy(.33f);
            make.bottom.equalTo(self.mas_bottom).offset(CL__SCALE(- 15.f));
        }];
    }
}

- (void)setNumbers:(NSArray *)numbers {
    
    self.d11View.numbers = numbers;
}

#pragma mark --- Get Method ---
- (UILabel *)lotteryNameLbl
{
    
    if (_lotteryNameLbl == nil) {
        
        _lotteryNameLbl = [[UILabel alloc] init];
        _lotteryNameLbl.backgroundColor = [UIColor clearColor];
        _lotteryNameLbl.font = FONT_SCALE(15);
        _lotteryNameLbl.textColor = UIColorFromRGB(0x333333);
    }
    return _lotteryNameLbl;
}

- (UILabel *)periodLabel
{
    
    if (_periodLabel == nil) {
        
        _periodLabel = [[UILabel alloc] init];
        _periodLabel.backgroundColor = [UIColor clearColor];
        _periodLabel.textColor = UIColorFromRGB(0x999999);
        _periodLabel.font = FONT_SCALE(12);
        
    }
    return _periodLabel;
}

- (UILabel *)timeLbl
{
    
    if (_timeLbl == nil) {
        
        _timeLbl = [[UILabel alloc] init];
        _timeLbl.backgroundColor = [UIColor clearColor];
        _timeLbl.font = FONT_SCALE(12);
        _timeLbl.textColor = UIColorFromRGB(0x999999);
        
    }
    return _timeLbl;
}

- (UILabel *)ShapeLabel
{
    
    if (_ShapeLabel == nil) {
        
        _ShapeLabel = [[UILabel alloc] init];
        _ShapeLabel.backgroundColor = [UIColor clearColor];
        _ShapeLabel.textColor = UIColorFromRGB(0x999999);
        _ShapeLabel.font = FONT_SCALE(12);
    }
    return _ShapeLabel;
}

- (CLAwardNumberView *)d11View
{

    if (_d11View == nil) {
        
        _d11View =[[CLAwardNumberView alloc] init];
        _d11View.ballColor = THEME_COLOR;
        _d11View.space = CL__SCALE(5.f);
        _d11View.ballWidthHeight = CL__SCALE(35.f);
    }
    return _d11View;
}


@end
