//
//  CLATBetBottomView.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/18.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLATBetBottomView.h"
#import "CLConfigMessage.h"
#import "UILabel+CLAttributeLabel.h"

#import "CLATManager.h"
#import "CLQLCManager.h"

@interface CLATBetBottomView ()

@property (nonatomic, strong) UIView *topLineView;

/**
 左侧 清空 按钮
 */
@property (nonatomic, strong) UIButton *leftButton;

/**
 右侧 确定 按钮
 */
@property (nonatomic, strong) UIButton *rightButton;

/**
 中间 说明label
 */
@property (nonatomic, strong) UILabel *midLabel;

/**
 中奖信息说明label
 */
@property (nonatomic, strong) UILabel *awardInfoLabel;

/**
 背景图
 */
@property (nonatomic, strong) UIImageView *backgroundImageView;

/**
 是否是清空按钮
 */
@property (nonatomic, assign) BOOL isClearButton;

@end

@implementation CLATBetBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColorFromRGB(0xffffff);
        self.isClearButton = NO;
        
        [self p_addSubviews];
        [self p_addConstraints];

    }
    return self;
}

- (void)p_addSubviews
{
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.awardInfoLabel];
    [self addSubview:self.leftButton];
    [self addSubview:self.rightButton];
    [self addSubview:self.midLabel];
    [self addSubview:self.topLineView];
    
}

- (void)p_addConstraints
{

    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(.5f);
    }];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10.f);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(CL__SCALE(70.f));
        make.height.mas_equalTo(CL__SCALE(35.f));
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10.f);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(CL__SCALE(70.f));
        make.height.mas_equalTo(CL__SCALE(35.f));
    }];
    [self.midLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self);
    }];
//    [self.awardInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_centerY).offset(5.f);
//        make.centerX.equalTo(self);
//    }];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

}

#pragma mark ------ public Mothed ------

- (void)reloadDataWithNoteNumber:(NSInteger)number hasSelectedOptions:(BOOL)isHas
{
    if ([[CLQLCManager shareManager] getCurrentPlayMethodType] == CLQLCPlayMothedTypeDanTuo) {
        
        self.leftButton.hidden = YES;
    }else{
        self.leftButton.hidden = NO;
    }

    NSString *noteStr = [NSString stringWithFormat:@"%zi注, 共%zi元", number, number * 2];
    NSRange noteRange = [noteStr rangeOfString:@"共"];
    
    AttributedTextParams *params1 = [AttributedTextParams attributeRange:NSMakeRange(noteRange.location + 1, noteStr.length - noteRange.location - 1) Color:UIColorFromRGB(0xd90000)];
    
    [self.midLabel attributeWithText:noteStr controParams:@[params1]];

    if (isHas) {
        [self.leftButton setTitle:@"清空" forState:UIControlStateNormal];
        self.leftButton.backgroundColor = UIColorFromRGB(0x999999);
        self.isClearButton = YES;
        self.leftButton.hidden = NO;
    }else{
        [self.leftButton setTitle:@"机选" forState:UIControlStateNormal];
        self.leftButton.backgroundColor = UIColorFromRGB(0xFF9933);
        self.isClearButton = [[CLQLCManager shareManager] getCurrentPlayMethodType] == CLQLCPlayMothedTypeDanTuo;
    }
}


#pragma mark ------ event Response ------
- (void)leftButtonOnClick:(UIButton *)btn{
    //    NSLog(@"点击了清空按钮");
    self.clearButtonClickBlock ? self.clearButtonClickBlock(self.isClearButton) : nil;
}
- (void)rightButtonOnClick:(UIButton *)btn{
    //    NSLog(@"点击了确定按钮");
    self.confirmButtonClickBlock ? self.confirmButtonClickBlock() : nil;
}
#pragma mark ------ getter Mothed ------

- (UIView *)topLineView{
    
    if (!_topLineView) {
        _topLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _topLineView.backgroundColor = UIColorFromRGB(0xdddddd);
    }
    return _topLineView;
}
- (UIButton *)leftButton{
    
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_leftButton setTitle:@"机选" forState:UIControlStateNormal];
        [_leftButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _leftButton.backgroundColor = UIColorFromRGB(0xFF9933);
        _leftButton.titleLabel.font = CL_FONT_SCALE(16.f);
        _leftButton.layer.cornerRadius = 2.f;
        [_leftButton addTarget:self action:@selector(leftButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
- (UIButton *)rightButton{
    
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_rightButton setTitle:@"确认" forState:UIControlStateNormal];
        [_rightButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _rightButton.backgroundColor = THEME_COLOR;
        _rightButton.titleLabel.font = CL_FONT_SCALE(16.f);
        _rightButton.layer.cornerRadius = 2.f;
        [_rightButton addTarget:self action:@selector(rightButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
- (UILabel *)midLabel{
    
    if (!_midLabel) {
        _midLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _midLabel.textColor = UIColorFromRGB(0x000000);
        _midLabel.font = CL_FONT_SCALE(16.f);
    }
    return _midLabel;
}
- (UILabel *)awardInfoLabel{
    
    if (!_awardInfoLabel) {
        _awardInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _awardInfoLabel.textColor = UIColorFromRGB(0x000000);
        _awardInfoLabel.font = FONT_SCALE(11);
    }
    return _awardInfoLabel;
}
- (UIImageView *)backgroundImageView{
    
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _backgroundImageView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _backgroundImageView;
}

@end
