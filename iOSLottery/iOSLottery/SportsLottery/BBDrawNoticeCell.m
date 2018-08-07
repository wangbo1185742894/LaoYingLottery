//
//  BBDrawNoticeCell.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBDrawNoticeCell.h"
#import "SLConfigMessage.h"
#import "SLDrawNoticeResultView.h"
#import "SLDrawNoticeModel.h"

#import "BBDrawNoticeResultView.h"

@interface BBDrawNoticeCell ()

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
 主队标签
 */
@property (nonatomic, strong) UILabel *hostTag;

/**
 客队名
 */
@property (nonatomic, strong) UILabel *awayName;

/**
 客队标签
 */
@property (nonatomic, strong) UILabel *awayTag;

/**
 全场比分
 */
@property (nonatomic, strong) UILabel *allScore;


/**
 开奖结果view
 */
@property (nonatomic, strong) BBDrawNoticeResultView *resultView;

/**
 底部分割线
 */
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation BBDrawNoticeCell

+ (id)creatDrawNoticeCellWithTableViewNew:(id)tableView
{
    
    return [self createBBDrawNoticeCellWithTableView:tableView];
}

+ (instancetype)createBBDrawNoticeCellWithTableView:(UITableView *)tableView
{
    
    static NSString *idcell = @"BBDrawNoticeCell";
    BBDrawNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:idcell];
    
    if (!cell) {
        cell = [[BBDrawNoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idcell];
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
    [self.contentView addSubview:self.awayTag];
    [self.contentView addSubview:self.hostTag];
    [self.contentView addSubview:self.allScore];
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
        
        make.top.equalTo(self.contentView.mas_top).offset(SL__SCALE(25.f));
        make.centerX.equalTo(self.contentView.mas_left).offset(SL__SCALE(220.f));
        make.width.mas_equalTo(SL__SCALE(80.f));
    }];
    
    
    [self.awayName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.allScore).offset(SL__SCALE(-5.f));
        make.right.equalTo(self.allScore.mas_left);
        make.width.mas_equalTo(SL__SCALE(115.f));
    }];
    
    [self.hostName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.allScore).offset(SL__SCALE(-5.f));;
        make.left.equalTo(self.allScore.mas_right);

        make.width.mas_equalTo(SL__SCALE(115.f));
    }];
    
    [self.awayTag mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.awayName.mas_bottom).offset(SL__SCALE(4.f));
        make.centerX.equalTo(self.awayName);
    }];
    
    [self.hostTag mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.hostName.mas_bottom).offset(SL__SCALE(4.f));
        make.centerX.equalTo(self.hostName);
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
    
    cellModel = cellModel;
    
    self.leagueName.text = cellModel.leagueMatches;
    self.matchTime.text = cellModel.matchIssue;
    self.startTime.text = cellModel.matchStartTime;
    
    self.hostName.text = cellModel.hostName;
    self.awayName.text = cellModel.awayName;
    
    self.allScore.text = cellModel.score;
    
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
        _hostName.text = @"俄克拉荷马雷霆";
        _hostName.textColor = SL_UIColorFromRGB(0x333333);
        _hostName.textAlignment = NSTextAlignmentCenter;
        _hostName.font = SL_FONT_BOLD(14.f);
    }
    
    return _hostName;
}

- (UILabel *)hostTag
{

    if (_hostTag == nil) {
        
        _hostTag = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _hostTag.text = @"[主]";
        _hostTag.textColor = SL_UIColorFromRGB(0x999999);
        _hostTag.textAlignment = NSTextAlignmentLeft;
        _hostTag.font = SL_FONT_SCALE(12.f);
    }
    
    return _hostTag;
    
}

- (UILabel *)awayName
{
    
    if (_awayName == nil) {
        
        _awayName = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _awayName.text = @"圣安东尼奥马刺";
        _awayName.textColor = SL_UIColorFromRGB(0x333333);
        _awayName.textAlignment = NSTextAlignmentCenter;
        _awayName.font = SL_FONT_BOLD(14.f);
    }
    
    return _awayName;
    
}

- (UILabel *)awayTag
{

    if (_awayTag == nil) {
        
        _awayTag = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _awayTag.text = @"[客]";
        _awayTag.textColor = SL_UIColorFromRGB(0x999999);
        _awayTag.textAlignment = NSTextAlignmentLeft;
        _awayTag.font = SL_FONT_SCALE(12.f);
    }
    
    return _awayTag;
    
}

- (UILabel *)allScore
{
    
    if (_allScore == nil) {
        
        _allScore = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _allScore.text = @"199:188";
        _allScore.textColor = SL_UIColorFromRGB(0xFC5548);
        _allScore.textAlignment = NSTextAlignmentCenter;
        _allScore.font = SL_FONT_BOLD(18.f);
    }
    
    return _allScore;
    
}

- (BBDrawNoticeResultView *)resultView
{
    
    if (_resultView == nil) {
        
        _resultView = [[BBDrawNoticeResultView alloc] initWithFrame:(CGRectZero)];
        
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
