//
//  SLMatchTitleView.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/11.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLConfigMessage.h"

#import "SLMatchTitleView.h"

#import "SLMatchBetModel.h"

#import "UILabel+SLAttributeLabel.h"

@interface SLMatchTitleView ()

/**
 左侧球队
 */
@property (nonatomic, strong) UILabel *leftTeamLabel;

/**
 中间VS
 */
@property (nonatomic, strong) UILabel *vsLabel;

/**
 右侧球队
 */
@property (nonatomic, strong) UILabel *rightTeamLabel;

@end

@implementation SLMatchTitleView

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
    [self addSubview:self.vsLabel];
    [self addSubview:self.rightTeamLabel];
}

- (void)addConstraints
{

    [self.leftTeamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.vsLabel.mas_left).offset(SL__SCALE(-10.f));
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.vsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.leftTeamLabel);
        make.width.mas_equalTo(SL__SCALE(19.f));
        make.height.mas_equalTo(SL__SCALE(14.f));
        
    }];
    
    [self.rightTeamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
     
        make.left.equalTo(self.vsLabel.mas_right).offset(SL__SCALE(10.f));
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(self.mas_centerY);
        
    }];

}

- (void)setleftTeamName:(NSString *)leftName rightTeamName:(NSString *)rigthName
{
    self.leftTeamLabel.text = leftName;
    
    self.rightTeamLabel.text = rigthName;
}

- (void)setTitleModel:(SLMatchBetModel *)titleModel
{

    _titleModel = titleModel;
    
    //校验主队名字是否存在
    if (titleModel.host_name && titleModel.host_name.length > 0) {
        
        //校验主队排名是否存在
        if (titleModel.host_rank && titleModel.host_rank.length) {
            
            NSString *leftString = [NSString stringWithFormat:@"%@%@",titleModel.host_rank,titleModel.host_name];
            [self.leftTeamLabel sl_attributeWithText:leftString controParams:@[[SLAttributedTextParams attributeRange:[leftString rangeOfString:titleModel.host_rank] Font:SL_FONT_SCALE(12)]]];
            
        }else{
        
            self.leftTeamLabel.text = titleModel.host_name;
        
        }
    }
//
    //校验客队名字是否存在
    if (titleModel.away_name && titleModel.away_name.length > 0) {
        
        //校验客队排名是否存在
        if (titleModel.away_rank && titleModel.away_rank.length > 0) {
            
            
            NSString *rightString = [NSString stringWithFormat:@"%@%@",titleModel.away_name,titleModel.away_rank];
            [self.rightTeamLabel sl_attributeWithText:rightString controParams:@[[SLAttributedTextParams attributeRange:[rightString rangeOfString:titleModel.away_rank] Font:SL_FONT_SCALE(12)]]];
        }else{
        
            self.rightTeamLabel.text = titleModel.away_name;
        }
    }
//
    //校验主队是否飘红
    self.leftTeamLabel.textColor = (titleModel.host_team_red_status  && titleModel.host_team_red_status == 1) ? SL_UIColorFromRGB(0xE63222) : SL_UIColorFromRGB(0x333333);
//
    //校验客队是否飘红
    self.rightTeamLabel.textColor = (titleModel.away_team_red_status  && titleModel.away_team_red_status == 1) ? SL_UIColorFromRGB(0xE63222) : SL_UIColorFromRGB(0x333333);

}


#pragma mark --- Get Method ---

- (UILabel *)leftTeamLabel
{

    if (_leftTeamLabel == nil) {
        
        _leftTeamLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        //_leftTeamLabel.text = @"[36]马德里没有眼泪";
        _leftTeamLabel.textColor = SL_UIColorFromRGB(0x333333);
        _leftTeamLabel.font = SL_FONT_BOLD(14.f);
        _leftTeamLabel.textAlignment = NSTextAlignmentRight;
        
        NSString *leftString = @"[36]马德里没有眼泪";
        [self.leftTeamLabel sl_attributeWithText:leftString controParams:@[[SLAttributedTextParams attributeRange:[leftString rangeOfString:@"[36]"] Font:SL_FONT_SCALE(12)]]];
        
    }
    
    return _leftTeamLabel;
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
        //_rightTeamLabel.text = @"北上广依然陶醉[88]";
        _rightTeamLabel.textColor = SL_UIColorFromRGB(0x333333);
        _rightTeamLabel.font = SL_FONT_BOLD(14.f);
        _rightTeamLabel.textAlignment = NSTextAlignmentLeft;
        
        NSString *rightString = @"北上广依然陶醉[88]";
        [self.rightTeamLabel sl_attributeWithText:rightString controParams:@[[SLAttributedTextParams attributeRange:[rightString rangeOfString:@"[88]"] Font:SL_FONT_SCALE(12)]]];
    }
    
    return _rightTeamLabel;
}

@end
