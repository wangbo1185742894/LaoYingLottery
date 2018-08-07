//
//  SLDrawNoticeCell.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/18.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLDrawNoticeCell.h"
#import "SLConfigMessage.h"
#import "SLDrawNoticeResultView.h"
#import "SLDrawNoticeModel.h"

@interface SLDrawNoticeCell ()

/**
 联赛名label
 */
@property (nonatomic, strong) UILabel *leagueName;

/**
 比赛时间label
 */
@property (nonatomic, strong) UILabel *matchTime;

/**
 比赛开始时间
 */
@property (nonatomic, strong) UILabel *startTime;

/**
 主队名
 */
@property (nonatomic, strong) UILabel *hostName;

/**
 客队名
 */
@property (nonatomic, strong) UILabel *awayName;

/**
 全场比分
 */
@property (nonatomic, strong) UILabel *allScore;

/**
 半全场比分
 */
@property (nonatomic, strong) UILabel *halfScore;

/**
 开奖结果view
 */
@property (nonatomic, strong) SLDrawNoticeResultView *resultView;

/**
 底部分割线
 */
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation SLDrawNoticeCell

+ (id)creatDrawNoticeCellWithTableViewNew:(id)tableView
{

    return [self createDrawNoticeCellWithTableView:tableView];
}

+ (instancetype)createDrawNoticeCellWithTableView:(UITableView *)tableView
{

    static NSString *idcell = @"SLDrawNoticeCell";
    SLDrawNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:idcell];
    
    if (!cell) {
        cell = [[SLDrawNoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idcell];
    }
    return cell;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self addSubviews];
        [self addConstraints];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return self;
}

- (void)addSubviews
{
    
    [self.contentView addSubview:self.leagueName];
    [self.contentView addSubview:self.matchTime];
    [self.contentView addSubview:self.startTime];
    [self.contentView addSubview:self.hostName];
    [self.contentView addSubview:self.awayName];
    [self.contentView addSubview:self.allScore];
    [self.contentView addSubview:self.halfScore];
    [self.contentView addSubview:self.resultView];
    [self.contentView addSubview:self.bottomLine];
}

- (void)addConstraints
{
    
    [self.leagueName mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.contentView.mas_left).offset(SL__SCALE(38.f));
        make.top.equalTo(self.contentView.mas_top).offset(SL__SCALE(10.f));
        make.height.mas_equalTo(SL__SCALE(17.f));
    }];
    
    [self.matchTime mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.leagueName.mas_bottom).offset(SL__SCALE(3.f));
        make.centerX.equalTo(self.leagueName.mas_centerX);
        make.height.mas_equalTo(SL__SCALE(16.f));
    }];
    
    [self.startTime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.matchTime.mas_bottom).offset(SL__SCALE(3.f));
        make.centerX.equalTo(self.leagueName.mas_centerX);
        make.height.mas_equalTo(SL__SCALE(16.f));
    }];
    
    [self.allScore mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.contentView.mas_top).offset(SL__SCALE(18.f));
        make.centerX.equalTo(self.contentView.mas_left).offset(SL__SCALE(226.f));
//        make.centerX.equalTo(self.contentView.mas_right).multipliedBy(0.4);
        
        make.width.mas_equalTo(SL__SCALE(50.f));
        
    }];
    
    [self.halfScore mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(self.allScore.mas_bottom).offset(2.f);
        make.centerX.equalTo(self.allScore.mas_centerX);
    }];
    
    [self.awayName mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(self.contentView.mas_top).offset(24.f);
        make.left.equalTo(self.allScore.mas_right).offset(SL__SCALE(5.f));
        make.height.mas_equalTo(SL__SCALE(17.f));
        make.width.mas_equalTo(SL__SCALE(100.f));
    }];
    
    [self.hostName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.awayName.mas_top);
        make.right.equalTo(self.allScore.mas_left).offset(SL__SCALE(-5.f));
        make.height.equalTo(self.awayName.mas_height);
        make.width.equalTo(self.awayName.mas_width);
    }];
    

    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.startTime.mas_bottom).offset(SL__SCALE(2.f));
        make.left.right.equalTo(self.contentView);
    
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.resultView.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(SL__SCALE(5.f));
        make.bottom.equalTo(self.contentView);
    }];
    
}

#pragma mark --- Set Method ---
- (void)setCellModel:(SLDrawNoticeModel *)cellModel
{

    _cellModel = cellModel;
    
    self.leagueName.text = cellModel.leagueMatches;
    self.matchTime.text = cellModel.matchIssue;
    self.startTime.text = cellModel.matchStartTime;
    
    self.hostName.text = cellModel.hostName;
    self.awayName.text = cellModel.awayName;
    
    self.allScore.text = cellModel.score;
    self.halfScore.text = cellModel.halfScore;
    
    [self.resultView setDataWithArray:cellModel.awardSp isCancel:cellModel.isCancel];
    
    self.allScore.textColor = SL_UIColorFromStr(cellModel.matchResults);

}

#pragma mark --- Get Method ---

- (UILabel *)leagueName
{

    if (_leagueName == nil) {
        
        _leagueName = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _leagueName.text = @"英超";
        _leagueName.textColor = SL_UIColorFromRGB(0x8F6E51);
        _leagueName.textAlignment = NSTextAlignmentCenter;
        _leagueName.font = SL_FONT_SCALE(12.f);
    }
    
    return _leagueName;
}

- (UILabel *)matchTime
{

    if (_matchTime == nil) {
        
        _matchTime = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _matchTime.text = @"周六002";
        _matchTime.textColor = SL_UIColorFromRGB(0x8F6E51);
        _matchTime.textAlignment = NSTextAlignmentCenter;
        _matchTime.font = SL_FONT_SCALE(12.f);
    }
    
    return _matchTime;

}

- (UILabel *)startTime
{

    if (_startTime == nil) {
        
        _startTime = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _startTime.text = @"18:30";
        _startTime.textColor = SL_UIColorFromRGB(0x8F6E51);
        _startTime.textAlignment = NSTextAlignmentCenter;
        _startTime.font = SL_FONT_SCALE(12.f);
    }
    
    return _startTime;
}

- (UILabel *)hostName
{

    if (_hostName == nil) {
        
        _hostName = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _hostName.text = @"墨尔本城";
        _hostName.textColor = SL_UIColorFromRGB(0x8F6E51);
        _hostName.textAlignment = NSTextAlignmentRight;
        _hostName.font = SL_FONT_BOLD(14.f);
    }
    
    return _hostName;
}

- (UILabel *)awayName
{

    if (_awayName == nil) {
        
        _awayName = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _awayName.text = @"巴塞罗那";
        _awayName.textColor = SL_UIColorFromRGB(0x8F6E51);
        _awayName.textAlignment = NSTextAlignmentLeft;
        _awayName.font = SL_FONT_BOLD(14.f);
    }
    
    return _awayName;

}

- (UILabel *)allScore
{

    if (_allScore == nil) {
        
        _allScore = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _allScore.text = @"2:3";
        _allScore.textColor = SL_UIColorFromRGB(0xFC5548);
        _allScore.textAlignment = NSTextAlignmentCenter;
        _allScore.font = SL_FONT_BOLD(18.f);
    }
    
    return _allScore;

}

- (UILabel *)halfScore
{

    if (_halfScore == nil) {
        
        _halfScore = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _halfScore.text = @"半1:3";
        _halfScore.textColor = SL_UIColorFromRGB(0x999999);
        _halfScore.textAlignment = NSTextAlignmentCenter;
        _halfScore.font = SL_FONT_SCALE(10.f);
    }
    
    return _halfScore;

}

- (SLDrawNoticeResultView *)resultView
{

    if (_resultView == nil) {
        
        _resultView = [[SLDrawNoticeResultView alloc] initWithFrame:(CGRectZero)];
        
    }
    
    return _resultView;
}

- (UIView *)bottomLine
{

    if (_bottomLine == nil) {
        
        _bottomLine = [[UIView alloc] initWithFrame:(CGRectZero)];
        _bottomLine.backgroundColor = SL_UIColorFromRGB(0xEEEEEE);
    }
    
    return _bottomLine;
}


@end
