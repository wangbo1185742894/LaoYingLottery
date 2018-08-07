//
//  SLMatchInfoView.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLMatchInfoView.h"
#import "SLConfigMessage.h"
#import "SLMatchBetModel.h"

@interface SLMatchInfoView ()

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

@implementation SLMatchInfoView

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
        
        make.left.top.right.equalTo(self);
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
        make.top.equalTo(self.cutOffTime.mas_bottom).offset(SL__SCALE(2));
        make.bottom.equalTo(self.mas_bottom);
        
    }];

}

- (void)returnShowHistoryClick:(SLMatchInofBlock)block
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
- (void)setInfoModel:(SLMatchBetModel *)infoModel
{

    _infoModel = infoModel;
    
    //校验联赛名是否存在
    if (infoModel.season_pre && infoModel.season_pre.length > 0) {
        
        self.leagueName.text = infoModel.season_pre;
    }else{
    
        self.leagueName.text = @"";
    }

    //校验比赛时间是否存在
    if (infoModel.match_week && infoModel.match_sn && infoModel.match_week.length > 0 && infoModel.match_sn > 0) {
        
        self.matchTime.text = [NSString stringWithFormat:@"%@%@",infoModel.match_week,infoModel.match_sn];
    }else{
    
        self.matchTime.text = @"";
    }
    
    //校验投注截止时间是否存在
    if (infoModel.issue_time_desc && infoModel.issue_time.length > 0) {
        
        self.cutOffTime.text = infoModel.issue_time_desc;
    }else{
    
        self.cutOffTime.text = @"";
    }
    
    self.showHistory.selected = infoModel.isShowHistory;
}


#pragma mark --- Get Method ---

- (UILabel *)leagueName
{
    
    if (_leagueName == nil) {
        
        _leagueName = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _leagueName.text = @"英超";
        _leagueName.textColor = SL_UIColorFromRGB(0x8F6E51);
        _leagueName.textAlignment = NSTextAlignmentCenter;
        _leagueName.font = SL_FONT_SCALE(12);
    }
    
    return _leagueName;
}

- (UILabel *)matchTime
{
    
    if (_matchTime == nil) {
        
        _matchTime = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _matchTime.text = @"周六001";
        _matchTime.textAlignment = NSTextAlignmentCenter;
        _matchTime.textColor = SL_UIColorFromRGB(0x8F6E51);
        _matchTime.font = SL_FONT_SCALE(12);
    }
    
    return _matchTime;
}

- (UILabel *)cutOffTime
{

    if (_cutOffTime == nil) {
        
        _cutOffTime = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _cutOffTime.text = @"16:00截止";
        _cutOffTime.textAlignment = NSTextAlignmentCenter;
        _cutOffTime.textColor = SL_UIColorFromRGB(0x8F6E51);
        _cutOffTime.font = SL_FONT_SCALE(12);
    }
    
    return _cutOffTime;
    
}

- (UIButton *)showHistory
{
    
    if (_showHistory == nil) {
        
        _showHistory = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showHistory setImage:[UIImage imageNamed:@"no_show_history"] forState:(UIControlStateNormal)];
        [_showHistory setImage:[UIImage imageNamed:@"show_history"] forState:(UIControlStateSelected)];
        
        _showHistory.titleLabel.font = SL_FONT_SCALE(9);

        [_showHistory addTarget:self action:@selector(showHistoryClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _showHistory;
}

@end
