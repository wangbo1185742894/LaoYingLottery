//
//  BBMatchTitleView.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/4.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBMatchTitleView.h"

#import "SLConfigMessage.h"
#import "BBMatchModel.h"
#import "UILabel+SLAttributeLabel.h"
@interface BBMatchTitleView ()

/**
 左侧球队label
 */
@property (nonatomic, strong) UILabel *leftTeamLabel;

/**
 左侧球队排名Label
 */
@property (nonatomic, strong) UILabel *leftRankLabel;

/**
 中间VS
 */
@property (nonatomic, strong) UILabel *vsLabel;

/**
 右侧球队
 */
@property (nonatomic, strong) UILabel *rightTeamLabel;

/**
 左侧球队排名Label
 */
@property (nonatomic, strong) UILabel *rightRankLabel;

@end

@implementation BBMatchTitleView

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
    
    [self addSubview:self.leftTeamLabel];
    [self addSubview:self.leftRankLabel];
    [self addSubview:self.vsLabel];
    [self addSubview:self.rightTeamLabel];
    [self addSubview:self.rightRankLabel];
}

- (void)addConstraints
{
    
    [self.leftTeamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.vsLabel);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.vsLabel.mas_left).offset(SL__SCALE(-10.f));
    }];
    
    [self.leftRankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.leftTeamLabel.mas_bottom).offset(SL__SCALE(5.f));
        make.right.equalTo(self.leftTeamLabel);
        make.bottom.equalTo(self);
        
    }];
    
    [self.vsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.centerY.equalTo(self);
        
    }];
    
    [self.rightTeamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.vsLabel.mas_right).offset(SL__SCALE(10.f));
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(self.leftTeamLabel);
        
    }];
    
    [self.rightRankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.rightTeamLabel.mas_bottom).offset(SL__SCALE(5.f));
        make.left.equalTo(self.rightTeamLabel);
    }];
    
}

- (void)setAwayTeamText:(NSString *)text
{

    self.leftTeamLabel.text = text;
}

- (void)setAwayTeamRankText:(NSString *)text
{

    self.leftRankLabel.text = text;
    
}

- (void)setHostTeamText:(NSString *)text
{

    self.rightTeamLabel.text = text;
    
}


- (void)setHostTeamRankText:(NSString *)text
{

    self.rightRankLabel.text = text;
    
}

- (void)setShowRank:(BOOL)show
{

    self.leftRankLabel.hidden = !show;
    self.rightRankLabel.hidden = !show;
}

- (void)setTitleModel:(BBMatchModel *)titleModel
{
    
    _titleModel = titleModel;
    
    //校验主队名字是否存在
    /** 主队 */
    NSString *rightString = titleModel.host_name?[NSString stringWithFormat:@"%@[主]",titleModel.host_name]:@"";
    [self.rightTeamLabel sl_attributeWithText:rightString controParams:@[[SLAttributedTextParams attributeRange:[rightString  rangeOfString:@"[主]"] Font:SL_FONT_SCALE(12.f)]]];
    NSString *rightPreString = titleModel.season_pre?:@"";
    rightPreString = [rightPreString stringByAppendingString:titleModel.host_rank && titleModel.host_rank.length?[NSString stringWithFormat:@"[%@]",titleModel.host_rank]:@""];
    self.rightRankLabel.text = rightPreString.length?rightPreString:@"";
    /** 客队 */
    //校验主队名字是否存在
    NSString *leftString = titleModel.away_name?[NSString stringWithFormat:@"[客]%@",titleModel.away_name]:@"";
    [self.leftTeamLabel sl_attributeWithText:leftString controParams:@[[SLAttributedTextParams attributeRange:[leftString  rangeOfString:@"[客]"] Font:SL_FONT_SCALE(12.f)]]];
    NSString *leftPreString = titleModel.season_pre?:@"";
    leftPreString = [leftPreString stringByAppendingString:titleModel.away_rank&&titleModel.away_rank.length?[NSString stringWithFormat:@"[%@]",titleModel.away_rank]:@""];
    self.leftRankLabel.text = leftPreString.length?leftPreString:@"";
    //
    //校验主队是否飘红
    self.leftTeamLabel.textColor = (titleModel.away_team_red_status  && titleModel.away_team_red_status == 1) ? SL_UIColorFromRGB(0xE63222) : SL_UIColorFromRGB(0x333333);
    //
    //校验客队是否飘红
    self.rightTeamLabel.textColor = (titleModel.host_team_red_status  && titleModel.host_team_red_status == 1) ? SL_UIColorFromRGB(0xE63222) : SL_UIColorFromRGB(0x333333);
    
}


#pragma mark --- Get Method ---

- (UILabel *)leftTeamLabel
{
    
    if (_leftTeamLabel == nil) {
        
        _leftTeamLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _leftTeamLabel.text = @"[客]俄克拉荷马雷霆";
        _leftTeamLabel.textColor = SL_UIColorFromRGB(0x333333);
        _leftTeamLabel.font = SL_FONT_BOLD(14.f);
        _leftTeamLabel.textAlignment = NSTextAlignmentRight;
        
    }
    
    return _leftTeamLabel;
}

- (UILabel *)leftRankLabel
{

    if (_leftRankLabel == nil) {
        
        _leftRankLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _leftRankLabel.text = @"这是联赛名很长[88]";
        _leftRankLabel.textColor = SL_UIColorFromRGB(0x999999);
        _leftRankLabel.font = SL_FONT_BOLD(10.f);
        _leftRankLabel.textAlignment = NSTextAlignmentRight;
    }
    return _leftRankLabel;
}

- (UILabel *)vsLabel
{
    
    if (_vsLabel == nil) {
        
        _vsLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _vsLabel.text = @"VS";
        _vsLabel.textColor = SL_UIColorFromRGB(0x333333);
        _vsLabel.font = SL_FONT_BOLD(12.f);
        _vsLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _vsLabel;
}

- (UILabel *)rightTeamLabel
{
    
    if (_rightTeamLabel == nil) {
        
        _rightTeamLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _rightTeamLabel.text = @"洛杉矶湖人队队[主]";
        _rightTeamLabel.textColor = SL_UIColorFromRGB(0x333333);
        _rightTeamLabel.font = SL_FONT_BOLD(14.f);
        _rightTeamLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    return _rightTeamLabel;
}

- (UILabel *)rightRankLabel
{

    if (_rightRankLabel == nil) {
        
        _rightRankLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _rightRankLabel.text = @"这是联赛名很长[88]";
        _rightRankLabel.textColor = SL_UIColorFromRGB(0x999999);
        _rightRankLabel.font = SL_FONT_BOLD(10.f);
        _rightRankLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _rightRankLabel;
}

@end
