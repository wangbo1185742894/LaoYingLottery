//
//  SLMatchBetBottomView.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/13.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLMatchBetBottomView.h"
#import "SLConfigMessage.h"
#import "UIImage+SLImage.h"
#import "SLBetInfoCache.h"
#import "SLBetInfoManager.h"
@interface SLMatchBetBottomView ()

/**
 已选几场label
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 说明label
 */
@property (nonatomic, strong) UILabel *explainLabel;

/**
 清空按钮
 */
@property (nonatomic, strong) UIButton *emptyBtn;

/**
 确定按钮
 */
@property (nonatomic, strong) UIButton *sureBtn;

/**
 顶部分割线
 */
@property (nonatomic, strong) UIView *topLine;

@end

@implementation SLMatchBetBottomView

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubviews];
        [self addConstraints];
        self.backgroundColor = SL_UIColorFromRGB(0xFFFFFF);
    }

    return self;
}

//添加子控件
- (void)addSubviews
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.explainLabel];
    [self addSubview:self.emptyBtn];
    [self addSubview:self.sureBtn];
    [self addSubview:self.topLine];

}

//添加子控件约束
- (void)addConstraints
{

    [self.emptyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.mas_top).offset(SL__SCALE(8.f));
        make.left.equalTo(self.mas_left).offset(SL__SCALE(12.f));
        make.width.mas_equalTo(SL__SCALE(70.f));
        make.height.mas_equalTo(SL__SCALE(35.f));
        make.bottom.equalTo(self.mas_bottom).offset(SL__SCALE(SL_kDevice_Is_iPhoneX ? - 28.f : -8.f));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.emptyBtn.mas_top);
        make.left.equalTo(self.emptyBtn.mas_right).offset(SL__SCALE(10.f));
        make.right.equalTo(self.sureBtn.mas_left).offset(SL__SCALE(-10.f));
        
    }];
    
    [self.explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(self.emptyBtn.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.mas_right).offset(SL__SCALE(-12.f));
        make.centerY.equalTo(self.emptyBtn.mas_centerY);
        make.width.height.equalTo(self.emptyBtn);
    }];
    
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];

}

#pragma mark --- Set Method ---

- (void)returnEmpayClick:(SLBetBottomBtnBlock)block
{

    _emptyBlock = block;

}

- (void)returnSureClick:(SLBetBottomBtnBlock)block
{

    _sureBlock = block;

}
- (void)reloadUI{
    
    BOOL hasDanGuan = [SLBetInfoManager getSelectMatchHasDanGuan];
    NSInteger matchCount = [SLBetInfoManager getSelectMatchCount];
    
    if (hasDanGuan && matchCount > 0) {
        
        self.titleLabel.text = [NSString stringWithFormat:@"已选%ld场", matchCount];
        self.emptyBtn.enabled = YES;
        self.sureBtn.enabled = YES;
        
    }else if (matchCount == 0){
        
        self.titleLabel.text = [NSString stringWithFormat:@"请先选择比赛"];
        self.emptyBtn.enabled = NO;
        self.sureBtn.enabled = NO;
        
    }else if (!hasDanGuan && matchCount == 1){
        
        self.titleLabel.text = [NSString stringWithFormat:@"已选1场，还差1场"];
        self.emptyBtn.enabled = YES;
        self.sureBtn.enabled = NO;
        
    }else if (matchCount > 1){
        
        self.titleLabel.text = [NSString stringWithFormat:@"已选%zi场", matchCount];
        self.emptyBtn.enabled = YES;
        self.sureBtn.enabled = YES;
    }
    
}

#pragma mark --- Button Click ----

- (void)emptyBtnClick:(UIButton *)btn
{

    if (self.emptyBlock) {
        
        self.emptyBlock(btn);
        
        [self setOriginalState];
    }
}

- (void)sureBtnClick:(UIButton *)btn
{
    if (self.sureBlock) {
        
        self.sureBlock(btn);
    }
}

//设置清空状态
- (void)setOriginalState
{
    self.titleLabel.text = @"请先选择比赛";
    self.emptyBtn.enabled = NO;
    self.sureBtn.enabled = NO;
}

#pragma mark --- Get Method ---
- (UILabel *)titleLabel
{

    if (_titleLabel == nil) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _titleLabel.text = @"请先选择比赛";
        _titleLabel.textColor = SL_UIColorFromRGB(0x333333);
        _titleLabel.font = SL_FONT_SCALE(16);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }

    return _titleLabel;
}

- (UILabel *)explainLabel
{

    if (_explainLabel == nil) {
        
        _explainLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _explainLabel.text = @"最终赔率以出票为准";
        _explainLabel.textColor = SL_UIColorFromRGB(0x999999);
        _explainLabel.textAlignment = NSTextAlignmentCenter;
        _explainLabel.font = SL_FONT_BOLD(10);
    }
    
    return _explainLabel;
}

- (UIButton *)emptyBtn
{

    if (_emptyBtn == nil) {
        
        _emptyBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_emptyBtn setTitle:@"清空" forState:(UIControlStateNormal)];
        
        [_emptyBtn setTitleColor:SL_UIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
        [_emptyBtn setBackgroundImage:[UIImage sl_imageWithColor:SL_UIColorFromRGB(0X999999)] forState:(UIControlStateNormal)];
        
        [_emptyBtn setTitleColor:SL_UIColorFromRGB(0xFFFFFF) forState:(UIControlStateSelected)];
        [_emptyBtn setBackgroundImage:[UIImage sl_imageWithColor:SL_UIColorFromRGB(0xCCCCCC)] forState:(UIControlStateDisabled)];
        
        _emptyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _emptyBtn.titleLabel.font = SL_FONT_SCALE(16);
        
        [_emptyBtn setAdjustsImageWhenHighlighted:NO];
        
        _emptyBtn.layer.masksToBounds= YES;
        _emptyBtn.layer.cornerRadius = 4.f;
        
        _emptyBtn.enabled = NO;
        
        [_emptyBtn addTarget:self action:@selector(emptyBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }

    return _emptyBtn;
}

- (UIButton *)sureBtn
{

    if (_sureBtn == nil) {
        
        _sureBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_sureBtn setTitle:@"确定" forState:(UIControlStateNormal)];
        
        [_sureBtn setTitleColor:SL_UIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
        [_sureBtn setBackgroundImage:[UIImage sl_imageWithColor:SL_UIColorFromRGB(0xE63222)] forState:(UIControlStateNormal)];
        
        [_sureBtn setTitleColor:SL_UIColorFromRGB(0xFFFFFF) forState:(UIControlStateSelected)];
        [_sureBtn setBackgroundImage:[UIImage sl_imageWithColor:SL_UIColorFromRGB(0xF29890)] forState:(UIControlStateDisabled)];
        
        _sureBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _sureBtn.titleLabel.font = SL_FONT_SCALE(16);
        
        [_sureBtn setAdjustsImageWhenHighlighted:NO];
        
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.layer.cornerRadius = 4.f;
        
        _sureBtn.enabled = NO;
        
        [_sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _sureBtn;

}

- (UIView *)topLine
{

    if (_topLine == nil) {
        
        _topLine = [[UIView alloc] initWithFrame:(CGRectZero)];
        _topLine.backgroundColor = SL_UIColorFromRGB(0xEEEEEE);
    }
    
    return _topLine;
}

@end
