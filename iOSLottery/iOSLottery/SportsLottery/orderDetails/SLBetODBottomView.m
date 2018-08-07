//
//  SLBetODBottomView.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/27.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLBetODBottomView.h"

#import "SLConfigMessage.h"

@interface SLBetODBottomView ()

@property (nonatomic, strong) UIButton *mainBtn;

@property (nonatomic, strong) UIView *topLine;

@end

@implementation SLBetODBottomView

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubviews];
        [self addConstraints];
        self.backgroundColor = [UIColor whiteColor];
    }

    return self;
}

- (void)addSubviews
{
    
    [self addSubview:self.mainBtn];
    [self addSubview:self.topLine];

}

- (void)addConstraints
{
 
    [self.mainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.mas_equalTo(SL__SCALE(280));
        make.height.mas_equalTo(SL__SCALE(35.f));
        make.centerX.centerY.equalTo(self);
    }];
    
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.mas_top);
    }];
    
}

- (void)mainBtnClick
{

    !self.btnClick ? nil : self.btnClick();

}

#pragma mark --- Get Method ---
-(UIButton *)mainBtn
{

    if (_mainBtn == nil) {
        
        _mainBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        [_mainBtn setTitle:@"立即投注" forState:(UIControlStateNormal)];
        
        _mainBtn.backgroundColor = SL_UIColorFromRGB(0xE63222);
        
        [_mainBtn setTitleColor:SL_UIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
        
        _mainBtn.layer.masksToBounds = YES;
        _mainBtn.layer.cornerRadius = 4.f;
        _mainBtn.titleLabel.font = SL_FONT_SCALE(16);
        
        [_mainBtn addTarget:self action:@selector(mainBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _mainBtn;
    
}

- (UIView *)topLine
{

    if (_topLine == nil) {
        
        _topLine = [[UIView alloc] initWithFrame:(CGRectZero)];
        _topLine.backgroundColor = SL_UIColorFromRGB(0xECE5DD);
    }
    
    return _topLine;
    
}

@end
