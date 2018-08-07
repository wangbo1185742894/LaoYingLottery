//
//  SLBottomBtnView.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/11.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLBottomBtnView.h"

#import "SLConfigMessage.h"

@interface SLBottomBtnView ()

@property (nonatomic, strong) UIView *topShareView;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIButton *sureBtn;

@end

@implementation SLBottomBtnView

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.clipsToBounds = NO;
        
        [self addSubviews];
        [self addConstraints];
    
    }

    return self;
}

- (void)addSubviews
{
    [self addSubview:self.topShareView];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.sureBtn];
}

- (void)addConstraints
{
    
    [self.topShareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(1.f);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(SL__SCALE(20));
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_centerX).offset(SL__SCALE(-10));
        make.height.mas_equalTo(SL__SCALE(35.f));
        
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(SL__SCALE(-20));
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_centerX).offset(SL__SCALE(10));
        make.height.mas_equalTo(SL__SCALE(35.f));
        
    }];
    
}

- (void)returnCancelClick:(SLBottomBtnBlock)block
{

    self.cancelBlock = block;

}

- (void)returnSureClick:(SLBottomBtnBlock)block
{

    self.sureBlock = block;
    
}

#pragma mark --- Button Click ---
- (void)cancelButtonClick
{

    if (self.cancelBlock != nil) {
        
        self.cancelBlock();
    }
    
}

- (void)sureButtonClick
{
    
    if (self.sureBlock != nil) {
        
        self.sureBlock();
    }
    
}

#pragma mark --- Get Method ---
- (UIView *)topShareView
{
    if (!_topShareView) {
        _topShareView = [[UIView alloc] init];
        _topShareView.backgroundColor = SL_UIColorFromRGB(0xece5dd);
        _topShareView.clipsToBounds = NO;
        _topShareView.layer.shadowOffset=CGSizeMake(0,-1.f);
        
        _topShareView.layer.shadowOpacity = 0.1;
        _topShareView.layer.shadowRadius = 1.f;
        _topShareView.layer.shadowColor = SL_UIColorFromRGB(0x333333).CGColor;
    }
    return _topShareView;
}

- (UIButton *)cancelBtn
{
    
    if (_cancelBtn == nil) {
        
        _cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        [_cancelBtn setTitleColor:SL_UIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        _cancelBtn.layer.masksToBounds = YES;
        _cancelBtn.layer.cornerRadius = 4.f;
        _cancelBtn.layer.borderColor = SL_UIColorFromRGB(0xECE5DD).CGColor;
        _cancelBtn.layer.borderWidth = 1.f;
        _cancelBtn.titleLabel.font = SL_FONT_SCALE(16);
        [_cancelBtn addTarget:self action:@selector(cancelButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _cancelBtn;
}

- (UIButton *)sureBtn
{
    
    if (_sureBtn == nil) {
        
        _sureBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_sureBtn setTitle:@"确定" forState:(UIControlStateNormal)];
        [_sureBtn setTitleColor:SL_UIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
        _sureBtn.backgroundColor = SL_UIColorFromRGB(0xE63222);
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.layer.cornerRadius = 4.f;
        _sureBtn.titleLabel.font = SL_FONT_SCALE(16);
        [_sureBtn addTarget:self action:@selector(sureButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _sureBtn;
}

@end
