//
//  CLATChoosePlayMothedView.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/14.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLATChoosePlayMothedView.h"

#import "CLDElevenPlayMothedButton.h"

#import "CLConfigMessage.h"

#import "CLATManager.h"

@interface CLATChoosePlayMothedView ()

/**
 直选选项
 */
@property (nonatomic, strong) CLDElevenPlayMothedButton *directButton;

/**
 组三单式选项
 */
@property (nonatomic, strong) CLDElevenPlayMothedButton *groupThreeSimpleButton;

/**
 组三复式选项
 */
@property (nonatomic, strong) CLDElevenPlayMothedButton *groupThreeDoubleButton;

/**
 组六选项
 */
@property (nonatomic, strong) CLDElevenPlayMothedButton *groupSixButton;

@end

@implementation CLATChoosePlayMothedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self p_addSubviews];
        [self p_addConstraints];
        
        self.layer.shadowColor = UIColorFromRGB(0x333333).CGColor;
        self.layer.shadowOffset = CGSizeMake(3, 3);
        self.layer.shadowOpacity = 0.1;
        self.backgroundColor = UIColorFromRGB(0xf7f7ee);
    }
    return self;
}

- (void)p_addSubviews
{
    [self addSubview:self.directButton];
    [self addSubview:self.groupThreeSimpleButton];
    [self addSubview:self.groupThreeDoubleButton];
    [self addSubview:self.groupSixButton];
}

- (void)p_addConstraints
{

    [self.directButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.mas_centerY).offset(CL__SCALE(-5.f));
        make.right.equalTo(self.mas_centerX).offset(CL__SCALE(- 7.5f));
        make.width.mas_equalTo(CL__SCALE(108.f));
        make.height.mas_equalTo(CL__SCALE(36.f));
    }];
    
    [self.groupThreeSimpleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.mas_centerY).offset(CL__SCALE(-5.f));
        make.left.equalTo(self.mas_centerX).offset(CL__SCALE(7.5f));
        make.width.height.equalTo(self.directButton);
       
    }];
    
    [self.groupThreeDoubleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_centerY).offset(CL__SCALE(5.f));
        make.right.equalTo(self.mas_centerX).offset(CL__SCALE(-7.5f));
        make.width.height.equalTo(self.directButton);
    }];
    
    [self.groupSixButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_centerY).offset(CL__SCALE(5.f));
        make.left.equalTo(self.mas_centerX).offset(CL__SCALE(7.5f));
        make.width.height.equalTo(self.directButton);
    }];
}

- (void)layoutSubviews
{

    [super layoutSubviews];
    
    CLDElevenPlayMothedButton *button = (CLDElevenPlayMothedButton *)[self viewWithTag:[[CLATManager shareManager] getCurrentPlayMethodType] + 100];
    
    if (button == nil || ![button isKindOfClass:CLDElevenPlayMothedButton.class]) return;
    
    button.selected = YES;
}

- (void)p_chooseButtonClick:(UIButton *)button
{
    
    self.directButton.selected = NO;
    self.groupThreeSimpleButton.selected = NO;
    self.groupThreeDoubleButton.selected = NO;
    self.groupSixButton.selected = NO;
    
    button.selected = YES;
    
    [[CLATManager shareManager] setCurrentPlayMethod:button.tag - 100];
    
    self.reloadData ? self.reloadData() : nil;
}


#pragma mark ------------ getter Mothed ------------

- (CLDElevenPlayMothedButton *)directButton
{
    
    if (!_directButton) {
        
        _directButton = [self p_createChooseButtonWithTitle:@"直选" tag:CLATPlayMothedTypeOne + 100];
    }
    return _directButton;
}

- (CLDElevenPlayMothedButton *)groupThreeSimpleButton
{
    
    if (!_groupThreeSimpleButton) {
        
        _groupThreeSimpleButton = [self p_createChooseButtonWithTitle:@"组三单式" tag:CLATPlayMothedTypeTwo + 100];
    }
    return _groupThreeSimpleButton;
}

- (CLDElevenPlayMothedButton *)groupThreeDoubleButton
{
    
    if (!_groupThreeDoubleButton) {
        
        _groupThreeDoubleButton = [self p_createChooseButtonWithTitle:@"组三复式" tag:CLATPlayMothedTypeThree + 100];
    }
    return _groupThreeDoubleButton;
}

- (CLDElevenPlayMothedButton *)groupSixButton
{
    
    if (!_groupSixButton) {
        
        _groupSixButton = [self p_createChooseButtonWithTitle:@"组六" tag:CLATPlayMothedTypeFour + 100];
    }
    return _groupSixButton;
}

- (CLDElevenPlayMothedButton *)p_createChooseButtonWithTitle:(NSString *)title tag:(NSInteger)tag
{
    CLDElevenPlayMothedButton *button = [[CLDElevenPlayMothedButton alloc] initWithFrame:CGRectZero];
    
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = FONT_SCALE(16.f);
    
    [button setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
    [button setTitleColor:THEME_COLOR forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(p_chooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 2.f;
    button.layer.borderColor = UIColorFromRGB(0xcbbdaa).CGColor;
    button.layer.borderWidth = .5f;
    
    button.tag = tag;
    
    return button;
}


@end

