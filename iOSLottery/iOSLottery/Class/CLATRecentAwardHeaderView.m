//
//  CLATRecentAwardHeaderView.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/13.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLATRecentAwardHeaderView.h"
#import "CLConfigMessage.h"

@interface CLATRecentAwardHeaderView ()

/**
 期次label
 */
@property (nonatomic, strong) UILabel *periodLabel;

/**
 开奖号码label
 */
@property (nonatomic, strong) UILabel *bonusNumberLabel;

/**
 形态Label
 */
@property (nonatomic, strong) UILabel *formLabel;

/**
 试机号
 */
@property (nonatomic, strong) UILabel *testNumber;


@end

@implementation CLATRecentAwardHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xeeeee5);

        [self p_addSubviews];
        
        [self p_addConstraints];
        
    }
    return self;
}

- (void)p_addSubviews
{
    [self addSubview:self.periodLabel];
    [self addSubview:self.bonusNumberLabel];
    [self addSubview:self.formLabel];
    [self addSubview:self.testNumber];
}

- (void)p_addConstraints
{

    [self.periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_left).offset(CL__SCALE(39.f));
        make.centerY.equalTo(self);
    }];
    
    [self.bonusNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_left).offset(CL__SCALE(161.f));
        make.centerY.equalTo(self);
    }];
    
    [self.formLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_left).offset(CL__SCALE(291.f));
        make.centerY.equalTo(self);
    }];
    
    [self.testNumber mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.centerX.equalTo(self.mas_left).offset(CL__SCALE(321.f));
        make.centerY.equalTo(self);
    }];
    
}
#pragma mark ------------ private Mothed ------------



- (void)setShowTestNumber:(BOOL)show
{

    if (show == NO) return;
        
        self.testNumber.hidden = NO;
        
        [self.bonusNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.mas_left).offset(CL__SCALE(121.f));
            
        }];
        
        [self.formLabel mas_updateConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.equalTo(self.mas_left).offset(CL__SCALE(231.f));
        }];
    
    [self updateConstraints];
        
}

- (void)setShowForm:(BOOL)show
{

    if (show == YES) return;
    
    self.formLabel.hidden = YES;
    
    [self.bonusNumberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.periodLabel.mas_right).offset(CL__SCALE(10.f));
        make.top.bottom.equalTo(self);
        make.right.equalTo(self);
        
    }];
    
    [self updateConstraints];
    
}

#pragma mark ------------ getter Mothed ------------
- (UILabel *)periodLabel{
    
    if (_periodLabel == nil) {

        _periodLabel = [self createLabelWithText:@"期次"];
    }
    return _periodLabel;
}
- (UILabel *)bonusNumberLabel{
    
    if (!_bonusNumberLabel) {

        _bonusNumberLabel = [self createLabelWithText:@"开奖号码"];
    }
    return _bonusNumberLabel;
}
- (UILabel *)formLabel
{
    
    if (_formLabel == nil ) {

        _formLabel = [self createLabelWithText:@"形态"];
    }
    return _formLabel;
}

- (UILabel *)testNumber
{

    if (_testNumber == nil) {
        
        _testNumber = [self createLabelWithText:@"试机号"];
        
        _testNumber.hidden = YES;
    }
    return _testNumber;
}

- (UILabel *)createLabelWithText:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    label.text = text;
    label.textColor = UIColorFromRGB(0x333333);
    label.font = FONT_SCALE(12);
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}


@end;

