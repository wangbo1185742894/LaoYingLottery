//
//  CLSFCMatchInfoView.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/26.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLSFCMatchInfoView.h"
#import "CLConfigMessage.h"

#import "CLSFCBetModel.h"

@interface CLSFCMatchInfoView ()

/**
 联赛名Label
 */
@property (nonatomic, strong) UILabel *leagueName;

/**
 比赛编号(截止时间)
 */
@property (nonatomic, strong) UILabel *matchTime;

/**
 投资截止时间
 */
@property (nonatomic, strong) UILabel *cutOffTime;

/**
 显示历史对战
 */
@property (nonatomic, strong) UIButton *showHistory;

@end

@implementation CLSFCMatchInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubviews];
        [self addConstraints];
        
        UITapGestureRecognizer *top = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHistoryClick)];
        
        [self addGestureRecognizer:top];
    }
    
    return self;
}

- (void)addSubviews
{
    [self addSubview:self.leagueName];
    [self addSubview:self.matchTime];
    [self addSubview:self.cutOffTime];
    [self addSubview:self.showHistory];
    
}

- (void)addConstraints
{
    
    [self.leagueName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(CL__SCALE(11.f));
    }];
    
    [self.matchTime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self);
        make.top.equalTo(self.leagueName.mas_bottom);
    }];
    
    [self.cutOffTime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self);
        make.top.equalTo(self.matchTime.mas_bottom);
        
    }];
    
    [self.showHistory mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.cutOffTime.mas_bottom).offset(CL__SCALE(2));
        
    }];
    
}

- (void)returnShowHistoryClick:(CLMatchInfoBlock)block
{
    
    _isShowStory = block;
}

#pragma mark --- ButtonClick ---
- (void)showHistoryClick
{
    
    self.infoModel.showHistory = !self.infoModel.isShowHistory;
    
    if (self.isShowStory) {
        
        self.isShowStory();
    }
}


#pragma mark --- Set Method ---
- (void)setInfoModel:(CLSFCBetModel *)infoModel
{
    
    _infoModel = infoModel;

    self.leagueName.text = infoModel.league;
        
    self.matchTime.text = infoModel.matchDay;
    
    self.cutOffTime.text = infoModel.matchStartTime;

    self.showHistory.selected = infoModel.isShowHistory;
}


#pragma mark --- Get Method ---

- (UILabel *)leagueName
{
    
    if (_leagueName == nil) {
        
        _leagueName = [self p_createLabel];
    }
    return _leagueName;
}

- (UILabel *)matchTime
{
    
    if (_matchTime == nil) {
        
        _matchTime = [self p_createLabel];
    }
    return _matchTime;
}

- (UILabel *)cutOffTime
{
    if (_cutOffTime == nil) {
        
        _cutOffTime = [self p_createLabel];
    }
    return _cutOffTime;
}

- (UILabel *)p_createLabel
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRectZero)];
    
    label.textColor = UIColorFromRGB(0x8F6E51);
    label.font = FONT_SCALE(12.f);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"测试";
    
    return label;
}

- (UIButton *)showHistory
{
    
    if (_showHistory == nil) {
        
        _showHistory = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showHistory setImage:[UIImage imageNamed:@"no_show_history"] forState:(UIControlStateNormal)];
        [_showHistory setImage:[UIImage imageNamed:@"show_history"] forState:(UIControlStateSelected)];
        
        _showHistory.titleLabel.font = FONT_SCALE(9.f);
        
        [_showHistory addTarget:self action:@selector(showHistoryClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _showHistory;
}

@end

