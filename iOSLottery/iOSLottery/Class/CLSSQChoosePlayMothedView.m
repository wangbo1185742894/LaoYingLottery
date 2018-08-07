//
//  CLSSQChoosePlayMothedView.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/2/27.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLSSQChoosePlayMothedView.h"
#import "CLDElevenPlayMothedButton.h"
#import "CLConfigMessage.h"
@interface CLSSQChoosePlayMothedView ()

@property (nonatomic, strong) CLDElevenPlayMothedButton *normalButton;//普通投注
@property (nonatomic, strong) CLDElevenPlayMothedButton *danTuoButton;//胆拖投注

@end

@implementation CLSSQChoosePlayMothedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.normalButton];
        [self addSubview:self.danTuoButton];
        [self configConstraint];
    }
    return self;
}

- (void)configConstraint{
    
    [self.normalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_centerX).offset(__SCALE(- 10.f));
        make.width.mas_equalTo(__SCALE(100.f));
        make.height.equalTo(self.normalButton.mas_width).multipliedBy(0.33);
    }];
    
    [self.danTuoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_centerX).offset(__SCALE(10.f));
        make.width.mas_equalTo(__SCALE(100.f));
        make.height.equalTo(self.normalButton.mas_width).multipliedBy(0.33);
    }];
}

#pragma mark ------------ setter Mothed ------------
- (void)setPlayMothedType:(CLSSQPlayMothedType)playMothedType{
    
    _playMothedType = playMothedType;
    switch (playMothedType) {
        case CLSSQPlayMothedTypeNormal:{
            self.normalButton.selected = YES;
            self.danTuoButton.selected = NO;
        }
            break;
        case CLSSQPlayMothedTypeDanTuo:{
            self.normalButton.selected = NO;
            self.danTuoButton.selected = YES;
        }
            break;
        
        default:
            break;
    }
}
#pragma mark ------------ event Response ------------
- (void)normalButtonOnClick:(UIButton *)btn{
    
    self.normalButton.selected = YES;
    self.danTuoButton.selected = NO;
    !self.switchPlayMothed ? : self.switchPlayMothed(CLSSQPlayMothedTypeNormal);
}
- (void)dantuoButtonOnClick:(UIButton *)btn{
    
    self.normalButton.selected = NO;
    self.danTuoButton.selected = YES;
    !self.switchPlayMothed ? : self.switchPlayMothed(CLSSQPlayMothedTypeDanTuo);
}

#pragma mark ------------ getter Mothed ------------
- (CLDElevenPlayMothedButton *)normalButton{
    
    if (!_normalButton) {
        _normalButton = [[CLDElevenPlayMothedButton alloc] initWithFrame:CGRectZero];
        [_normalButton setTitle:@"普通投注" forState:UIControlStateNormal];
        _normalButton.titleLabel.font = FONT_SCALE(14);
        [_normalButton setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        [_normalButton setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        [_normalButton addTarget:self action:@selector(normalButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        _normalButton.layer.cornerRadius = 2.f;
        _normalButton.layer.borderColor = UIColorFromRGB(0xcbbdaa).CGColor;
        _normalButton.layer.borderWidth = .5f;
    }
    return _normalButton;
}

- (CLDElevenPlayMothedButton *)danTuoButton{
    
    if (!_danTuoButton) {
        _danTuoButton = [[CLDElevenPlayMothedButton alloc] initWithFrame:CGRectZero];
        [_danTuoButton setTitle:@"胆拖投注" forState:UIControlStateNormal];
        _danTuoButton.titleLabel.font = FONT_SCALE(14);
        [_danTuoButton setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        [_danTuoButton setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        [_danTuoButton addTarget:self action:@selector(dantuoButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        _danTuoButton.layer.cornerRadius = 2.f;
        _danTuoButton.layer.borderColor = UIColorFromRGB(0xcbbdaa).CGColor;
        _danTuoButton.layer.borderWidth = .5f;
    }
    return _danTuoButton;
}
@end
