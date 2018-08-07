//
//  BBMatchInfoView.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBMatchInfoView.h"
#import "SLConfigMessage.h"
#import "BBMatchModel.h"

@interface BBMatchInfoView ()

/**
 联赛名Label
 */
@property (nonatomic, strong) UILabel *leagueNameLabel;

/**
 比赛编号(截止时间)
 */
@property (nonatomic, strong) UILabel *matchNumberLabel;

/**
 投资截止时间
 */
@property (nonatomic, strong) UILabel *cutOffTimeLabel;

/**
 箭头
 */
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation BBMatchInfoView

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
    [self addSubview:self.leagueNameLabel];
    [self addSubview:self.matchNumberLabel];
    [self addSubview:self.cutOffTimeLabel];
    [self addSubview:self.arrowImageView];
    
}

- (void)addConstraints
{
    
    [self.leagueNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(self);
    }];
    
    [self.matchNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self);
        make.top.equalTo(self.leagueNameLabel.mas_bottom);
    }];
    
    [self.cutOffTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self);
        make.top.equalTo(self.matchNumberLabel.mas_bottom);
        
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.cutOffTimeLabel.mas_bottom).offset(SL__SCALE(6.f));
        make.bottom.equalTo(self.mas_bottom);
        
        make.width.mas_equalTo(SL__SCALE(12.f));
        make.height.mas_equalTo(SL__SCALE(5.f));
        
    }];
    
}



#pragma mark --- ButtonClick ---
- (void)showHistoryClick
{
    
    self.infoModel.showHistory = !self.infoModel.isShowHistory;
    
    if (self.infoBlock) {
        
        self.infoBlock();
    }
}


- (void)setMatchLeagueName:(NSString *)str
{

    self.leagueNameLabel.text = str;
    
}

- (void)setMatchNumber:(NSString *)str
{

    self.matchNumberLabel.text = str;
    
}

- (void)setCutOffTime:(NSString *)str
{

    self.cutOffTimeLabel.text = str;
    
}


#pragma mark --- Set Method ---
- (void)setInfoModel:(BBMatchModel *)infoModel
{
    
    _infoModel = infoModel;
    
    //校验联赛名是否存在
    if (infoModel.season_pre && infoModel.season_pre.length > 0) {
        
        self.leagueNameLabel.text = infoModel.season_pre;
    }else{
        
        self.leagueNameLabel.text = @"";
    }
    
    //校验比赛时间是否存在
    if (infoModel.match_week && infoModel.match_sn && infoModel.match_week.length > 0 && infoModel.match_sn > 0) {
        
        self.matchNumberLabel.text = [NSString stringWithFormat:@"%@%@",infoModel.match_week,infoModel.match_sn];
    }else{
        
        self.matchNumberLabel.text = @"";
    }
    
    //校验投注截止时间是否存在
    if (infoModel.issue_time_desc && infoModel.issue_time.length > 0) {
        
        self.cutOffTimeLabel.text = infoModel.issue_time_desc;
    }else{
        
        self.cutOffTimeLabel.text = @"";
    }
    
    if (self.infoModel.isShowHistory) {
        
        self.arrowImageView.layer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
    }else{
        
        self.arrowImageView.layer.transform = CATransform3DMakeRotation(M_PI * 2, 1, 0, 0);
    }
}


#pragma mark --- Get Method ---

- (UILabel *)leagueNameLabel
{
    
    if (_leagueNameLabel == nil) {
        
        _leagueNameLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _leagueNameLabel.text = @"英超";
        _leagueNameLabel.textColor = SL_UIColorFromRGB(0x8F6E51);
        _leagueNameLabel.textAlignment = NSTextAlignmentCenter;
        _leagueNameLabel.font = SL_FONT_SCALE(12);
    }
    
    return _leagueNameLabel;
}

- (UILabel *)matchNumberLabel
{
    
    if (_matchNumberLabel == nil) {
        
        _matchNumberLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _matchNumberLabel.text = @"周六001";
        _matchNumberLabel.textAlignment = NSTextAlignmentCenter;
        _matchNumberLabel.textColor = SL_UIColorFromRGB(0x8F6E51);
        _matchNumberLabel.font = SL_FONT_SCALE(12);
    }
    
    return _matchNumberLabel;
}

- (UILabel *)cutOffTimeLabel
{
    
    if (_cutOffTimeLabel == nil) {
        
        _cutOffTimeLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _cutOffTimeLabel.text = @"16:00截止";
        _cutOffTimeLabel.textAlignment = NSTextAlignmentCenter;
        _cutOffTimeLabel.textColor = SL_UIColorFromRGB(0x8F6E51);
        _cutOffTimeLabel.font = SL_FONT_SCALE(12);
    }
    
    return _cutOffTimeLabel;
    
}

- (UIImageView *)arrowImageView
{

    if (_arrowImageView == nil) {
        
        _arrowImageView = [[UIImageView alloc] initWithFrame:(CGRectZero)];
        
        _arrowImageView.image = [UIImage imageNamed:@"no_show_history"];
    }
    return _arrowImageView;
}

@end

