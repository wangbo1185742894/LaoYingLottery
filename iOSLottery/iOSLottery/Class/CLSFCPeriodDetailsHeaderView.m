//
//  CLSFCPeriodDetailsHeaderView.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/11/2.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLSFCPeriodDetailsHeaderView.h"
#import "CLConfigMessage.h"

#import "CLSFCDrawNoticeView.h"

#import "CLAwardVoModel.h"

@interface  CLSFCPeriodDetailsHeaderView()

@property (nonatomic, strong) CLSFCDrawNoticeView *drawNoticeView;
@property (nonatomic, strong) UILabel *periodTitle;
@property (nonatomic, strong) UILabel *periodScale;
@property (nonatomic, strong) UILabel *bonusTitle;
@property (nonatomic, strong) UILabel *bonusScale;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *midLineView;


@end

@implementation CLSFCPeriodDetailsHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = UIColorFromRGB(0xFFFFFF);
        
        [self addSubview:self.drawNoticeView];
        [self addSubview:self.periodScale];
        [self addSubview:self.periodTitle];
        [self addSubview:self.bonusScale];
        [self addSubview:self.bonusTitle];
        [self addSubview:self.topLineView];
        [self addSubview:self.midLineView];
        [self configConstraint];
    }
    return self;
}

- (void)configConstraint{
    
    [self.drawNoticeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(__SCALE(90.f));
    }];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.drawNoticeView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(.5);
    }];
    
    [self.midLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.topLineView.mas_bottom).offset(__SCALE(10.f));
        make.bottom.equalTo(self).offset(__SCALE(-5.f));
        make.centerX.equalTo(self);
        make.width.mas_equalTo(0.5f);
    }];
    
    [self.periodTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.topLineView.mas_bottom).offset(CL__SCALE(14.f));
        make.centerX.equalTo(self.mas_right).multipliedBy(0.25);
    }];
    
    [self.periodScale mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.periodTitle.mas_bottom).offset(CL__SCALE(8.f));
        make.centerX.equalTo(self.periodTitle);
    }];
    
    [self.bonusTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.periodTitle);
        make.centerX.equalTo(self.mas_right).multipliedBy(0.75);
    }];
    
    [self.bonusScale mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.periodScale);
        make.centerX.equalTo(self.bonusTitle);
    }];
}

- (void)setData:(CLAwardVoModel *)data
{
    
    [self.drawNoticeView setData:data];
    
    NSArray *array = [data.periodSale componentsSeparatedByString:@"_"];
    
    if (array.count != 2) return;
    
    self.periodScale.text = array[0];
    self.bonusScale.text = array[1];
    
}
#pragma mark ------------ getter Mothed ------------
- (CLSFCDrawNoticeView *)drawNoticeView
{
    
    if (!_drawNoticeView) {
        
        _drawNoticeView = [[CLSFCDrawNoticeView alloc] initWithFrame:CGRectZero];
        
        _drawNoticeView.backgroundColor = UIColorFromRGB(0xffffff);
        
        [_drawNoticeView setShowInCenter:YES];
    }
    return _drawNoticeView;;
}

- (UILabel *)periodTitle{
    
    if (!_periodTitle) {
        _periodTitle = [[UILabel alloc] init];
        _periodTitle.font = FONT_SCALE(13.);
        _periodTitle.text = @"胜负彩销量(元)";
        _periodTitle.textColor = UIColorFromRGB(0x666666);
    }
    return _periodTitle;
}
- (UILabel *)bonusTitle{
    
    if (!_bonusTitle) {
        _bonusTitle = [[UILabel alloc] init];
        _bonusTitle.font = FONT_SCALE(13.);
        _bonusTitle.text = @"任选九(元)";
        _bonusTitle.textColor = UIColorFromRGB(0x666666);
    }
    return _bonusTitle;
}
- (UILabel *)periodScale{
    
    if (!_periodScale) {
        _periodScale = [[UILabel alloc] init];
        _periodScale.font = FONT_SCALE(13.);
        _periodScale.text = @"";
        _periodScale.textColor = THEME_COLOR;
    }
    return _periodScale;
}
- (UILabel *)bonusScale{
    
    if (!_bonusScale) {
        _bonusScale = [[UILabel alloc] init];
        _bonusScale.font = FONT_SCALE(13.);
        _bonusScale.text = @"";
        _bonusScale.textColor = THEME_COLOR;
    }
    return _bonusScale;
}

- (UIView *)topLineView{
    
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = UIColorFromRGB(0xeeeeee);
    }
    return _topLineView;
}
- (UIView *)midLineView{
    
    if (!_midLineView) {
        _midLineView = [[UIView alloc] init];
        _midLineView.backgroundColor = UIColorFromRGB(0xeeeeee);
    }
    return _midLineView;
}
@end

