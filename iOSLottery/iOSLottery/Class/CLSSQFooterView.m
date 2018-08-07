//
//  CLSSQFooterView.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/4.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLSSQFooterView.h"
#import "CLConfigMessage.h"
#import "UILabel+CLAttributeLabel.h"
@interface CLSSQFooterView ()

@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIButton *leftButton;//左侧 清空 按钮
@property (nonatomic, strong) UIButton *rightButton;//右侧 确定 按钮
@property (nonatomic, strong) UILabel *midLabel;//中间 说明label
@property (nonatomic, strong) UIImageView *backgroundImageView;//背景图
@property (nonatomic, assign) BOOL isClearButton;//是否是清空按钮

@end
@implementation CLSSQFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
        [self addSubview:self.midLabel];
        [self addSubview:self.topLineView];
        self.isClearButton = NO;
        [self configContraint];
    }
    return self;
}
#pragma mark ------ public Mothed ------
- (void)assignBetNote:(NSInteger)note hasSelectBetButton:(BOOL)hasSelectBetButton playMothed:(NSInteger)playMothed{
    
    if (playMothed == 1 && !hasSelectBetButton) {
        //表示胆拖 玩法 不显示机选
        self.leftButton.hidden = YES;
    }else{
        self.leftButton.hidden = NO;
    }
    if (hasSelectBetButton) {
        [self.leftButton setTitle:@"清空" forState:UIControlStateNormal];
        self.isClearButton = YES;
    }else{
        [self.leftButton setTitle:@"机选" forState:UIControlStateNormal];
        self.isClearButton = NO;
    }
    
    if (note == 0) {
        self.midLabel.text = @"";
        return;
    }
    
    NSString *text = [NSString stringWithFormat:@"%zi注 共%zi元", note, 2 * note];
    
    NSInteger loc = [text rangeOfString:@"共"].location;
    
    AttributedTextParams *params = [AttributedTextParams attributeRange:NSMakeRange(loc + 1, text.length - loc - 1) Color:THEME_COLOR];
    
    [self.midLabel attributeWithText:text controParams:@[params]];
    
}
#pragma mark ------ private Mothed ------
- (void)configContraint{
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(.5f);
    }];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10.f);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(__SCALE(65.f));
        make.height.mas_equalTo(__SCALE(34.f));
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(- 10.f);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(__SCALE(65.f));
        make.height.mas_equalTo(__SCALE(34.f));
    }];
    [self.midLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self);
    }];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
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
        _leftButton.backgroundColor = UIColorFromRGB(0x999999);
        _leftButton.titleLabel.font = FONT_SCALE(15);
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
        _rightButton.titleLabel.font = FONT_SCALE(15);
        _rightButton.layer.cornerRadius = 2.f;
        [_rightButton addTarget:self action:@selector(rightButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
- (UILabel *)midLabel{
    
    if (!_midLabel) {
        _midLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _midLabel.textColor = UIColorFromRGB(0x000000);
        _midLabel.font = FONT_SCALE(15.f);
    }
    return _midLabel;
}

- (UIImageView *)backgroundImageView{
    
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _backgroundImageView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _backgroundImageView;
}

@end
