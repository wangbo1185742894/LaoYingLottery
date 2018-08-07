//
//  CLSFCBetBottomView.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/26.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLSFCBetBottomView.h"
#import "CLConfigMessage.h"
#import "UIImage+SLImage.h"

#import "UILabel+CLAttributeLabel.h"

#import "CLSFCManager.h"

@interface CLSFCBetBottomView ()

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


@implementation CLSFCBetBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self p_addSubviews];
        [self p_addConstraints];
        
        self.backgroundColor = UIColorFromRGB(0xFFFFFF);
    }
    
    return self;
}

//添加子控件
- (void)p_addSubviews
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.explainLabel];
    [self addSubview:self.emptyBtn];
    [self addSubview:self.sureBtn];
    [self addSubview:self.topLine];
    
}

//添加子控件约束
- (void)p_addConstraints
{
    
    [self.emptyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(CL__SCALE(8.f));
        make.left.equalTo(self.mas_left).offset(CL__SCALE(12.f));
        make.width.mas_equalTo(CL__SCALE(70.f));
        make.height.mas_equalTo(CL__SCALE(35.f));
        make.bottom.equalTo(self.mas_bottom).offset(CL__SCALE(-7.f));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.emptyBtn.mas_top);
        make.left.equalTo(self.emptyBtn.mas_right).offset(CL__SCALE(10.f));
        make.right.equalTo(self.sureBtn.mas_left).offset(CL__SCALE(-10.f));
        
    }];
    
    [self.explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.emptyBtn.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(CL__SCALE(-12.f));
        make.centerY.equalTo(self.emptyBtn.mas_centerY);
        make.width.height.equalTo(self.emptyBtn);
    }];
    
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
}

#pragma mark --- Set Method ---

- (void)returnEmpayClick:(CLSFCBetBottomBlock)block
{
    
    _emptyBlock = block;
    
}

- (void)returnSureClick:(CLSFCBetBottomBlock)block
{
    
    _sureBlock = block;
    
}
- (void)reloadUI
{
    NSInteger number = [[CLSFCManager shareManager] getNoteNumber];
    
    NSString *noteStr = [NSString stringWithFormat:@"%zi注, 共%zi元", number, number * 2];
    NSRange noteRange = [noteStr rangeOfString:@"共"];
    
    AttributedTextParams *params1 = [AttributedTextParams attributeRange:NSMakeRange(noteRange.location + 1, noteStr.length - noteRange.location - 1) Color:UIColorFromRGB(0xd90000)];
    
    [self.titleLabel attributeWithText:noteStr controParams:@[params1]];
    
    
    
    NSInteger matchCount = [[CLSFCManager shareManager] getSelectOptionsCount];
    NSInteger minSelectedCount = [[CLSFCManager shareManager] getMinSelectOptionsCount];
    
    if  (matchCount >= minSelectedCount) {
        
        self.explainLabel.text = [NSString stringWithFormat:@"已选%ld场", matchCount];
        self.emptyBtn.enabled = YES;
        self.sureBtn.enabled = YES;
        
    }else if (matchCount == 0){
        
        self.explainLabel.text = [NSString stringWithFormat:@"请至少选择%ld场比赛",minSelectedCount];
        self.emptyBtn.enabled = NO;
        self.sureBtn.enabled = NO;
        
    }else if (matchCount < minSelectedCount){
    
        self.explainLabel.text = [NSString stringWithFormat:@"已选%ld场，还差%ld场",matchCount,minSelectedCount - matchCount];
        self.emptyBtn.enabled = YES;
        self.sureBtn.enabled = NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self];
    
    BOOL isContain = CGRectContainsPoint(self.sureBtn.frame, touchPoint);
    
    if (isContain == YES) {
        
        if (self.sureBtn.isEnabled == NO && self.emptyBtn.isEnabled == NO) {
            
            //[SLExternalService showError:@"请先选择比赛"];
            
            return;
        }
        
        if (self.sureBtn.isEnabled == NO && self.emptyBtn.isEnabled == YES) {
            
            //[SLExternalService showError:@"已选1场，还差一场"];
            
            return;
        }
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
    
    NSString *noteStr = @"0注, 共0元";
    NSRange noteRange = [noteStr rangeOfString:@"共"];
    
    AttributedTextParams *params1 = [AttributedTextParams attributeRange:NSMakeRange(noteRange.location + 1, noteStr.length - noteRange.location - 1) Color:UIColorFromRGB(0xd90000)];
    
    [self.titleLabel attributeWithText:noteStr controParams:@[params1]];

    self.emptyBtn.enabled = NO;
    self.sureBtn.enabled = NO;
}

#pragma mark --- Get Method ---
- (UILabel *)titleLabel
{
    
    if (_titleLabel == nil) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _titleLabel.text = @"";
        _titleLabel.textColor = UIColorFromRGB(0x333333);
        _titleLabel.font = FONT_SCALE(16.f);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLabel;
}

- (UILabel *)explainLabel
{
    
    if (_explainLabel == nil) {
        
        _explainLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _explainLabel.text = @"";
        _explainLabel.textColor = UIColorFromRGB(0x999999);
        _explainLabel.textAlignment = NSTextAlignmentCenter;
        _explainLabel.font = FONT_BOLD(10.f);
    }
    
    return _explainLabel;
}

- (UIButton *)emptyBtn
{
    
    if (_emptyBtn == nil) {
        
        _emptyBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_emptyBtn setTitle:@"清空" forState:(UIControlStateNormal)];
        
        [_emptyBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
        [_emptyBtn setBackgroundImage:[UIImage sl_imageWithColor:UIColorFromRGB(0X999999)] forState:(UIControlStateNormal)];
        
        [_emptyBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:(UIControlStateSelected)];
        [_emptyBtn setBackgroundImage:[UIImage sl_imageWithColor:UIColorFromRGB(0xCCCCCC)] forState:(UIControlStateDisabled)];
        
        _emptyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _emptyBtn.titleLabel.font = FONT_SCALE(16);
        
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
        
        [_sureBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
        [_sureBtn setBackgroundImage:[UIImage sl_imageWithColor:UIColorFromRGB(0xE63222)] forState:(UIControlStateNormal)];
        
        [_sureBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:(UIControlStateSelected)];
        [_sureBtn setBackgroundImage:[UIImage sl_imageWithColor:UIColorFromRGB(0xF29890)] forState:(UIControlStateDisabled)];
        
        _sureBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _sureBtn.titleLabel.font = FONT_SCALE(16);
        
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
        _topLine.backgroundColor = UIColorFromRGB(0xEEEEEE);
    }
    return _topLine;
}


@end
