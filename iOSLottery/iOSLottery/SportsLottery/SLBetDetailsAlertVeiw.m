//
//  SLBetDetailsAlertVeiw.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/23.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLBetDetailsAlertVeiw.h"
#import "SLConfigMessage.h"

@interface SLBetDetailsAlertVeiw ()


/**
 白色内容View
 */
@property (nonatomic, strong) UIView *contentView;

/**
 文字标题label
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 非单关描述文字
 */
@property (nonatomic, strong) UILabel *describeLabel;

/**
 确定按钮
 */
@property (nonatomic, strong) UIButton *sureBtn;

/**
 取消按钮
 */
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, assign) SLAlertType currentType;

@end

@implementation SLBetDetailsAlertVeiw

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubviews];
        [self addConstraints];
        
        self.backgroundColor = SL_UIColorFromRGBandAlpha(0x000000, 0.80);
    }
    return self;
}

- (void)addSubviews
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.describeLabel];
    [self.contentView addSubview:self.sureBtn];
    [self.contentView addSubview:self.cancelBtn];
    
    [self addSubview:self.contentView];
}

- (void)addConstraints
{

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(SL__SCALE(18.f));
        make.height.mas_equalTo(22.f);
    }];
    
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.titleLabel.mas_bottom).offset(SL__SCALE(5.f));
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(0);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.describeLabel.mas_bottom).offset(SL__SCALE(21.f));
        make.left.equalTo(self.contentView.mas_left).offset(SL__SCALE(10.f));
        make.width.mas_offset(SL__SCALE(120.f));
        make.height.mas_offset(SL__SCALE(35.f));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(SL__SCALE(-10.f));
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.sureBtn.mas_right).offset(SL__SCALE(10.f));
        make.width.height.centerY.equalTo(self.sureBtn);
        make.right.equalTo(self.contentView.mas_right).offset(SL__SCALE(-10.f));

    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.centerY.equalTo(self);
    }];
    

}

- (void)layoutSubviews
{

    [super layoutSubviews];
    
    self.frame = CGRectMake(0, 0, SL_SCREEN_WIDTH, SL_SCREEN_HEIGHT);
    
    [self updateConstraints];
}

- (void)showInWindowWithType:(SLAlertType)type matchIssue:(NSString *)matchIssue;
{
    self.matchIssue = matchIssue;
    switch (type) {
            
        case SLAlertTypeDelete:{
        
            [self setUpMessageWithDeleteType];
        }
            break;
            
        case SLAlertTypeEmpty:{

            [self setUpMessageWithEmptyType];
        }
            break;
            
        case SLAlertTypeCancel:{
            
            [self setUpMessageWithCancelType];
        }
            break;
            
        default:
            break;
    }
    
    //记录当前样式
    self.currentType = type;

    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

//设置删除样式下信息
- (void)setUpMessageWithDeleteType
{
    self.titleLabel.text = @"确定删除本场比赛吗？";
    [self.describeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(SL__SCALE(0));
    }];
    self.describeLabel.hidden = YES;
}

//设置清空样式下信息
- (void)setUpMessageWithEmptyType
{
    self.titleLabel.text = @"确定清空比赛列表吗？";
    [self.describeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(SL__SCALE(0));
    }];
    self.describeLabel.hidden = YES;
}

//设置取消订单样式下信息
- (void)setUpMessageWithCancelType
{
    self.titleLabel.text = @"是否取消投注订单？";
    [self.describeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(SL__SCALE(22.f));
    }];
    self.describeLabel.hidden = NO;
}

- (void)returnSureClick:(SLBetDetailsAlertBlock)block
{
    self.sureBlock = block;
}

- (void)returnCancelClick:(SLBetDetailsAlertBlock)block
{
    self.cancelBlock = block;
}

#pragma mark --- Button Click ---
//确定按钮点击事件
- (void)sureClick
{
    [self removeFromSuperview];
    
    !self.sureBlock ? : self.sureBlock(self.currentType, self.matchIssue);
    
}

//取消按钮点击事件
- (void)cancelClick
{
    [self removeFromSuperview];
    
    !self.cancelBlock ? : self.cancelBlock(self.currentType, self.matchIssue);
}



#pragma mark --- Get Method ---
- (UIView *)contentView
{

    if (_contentView == nil) {
        
        _contentView = [[UIView alloc] initWithFrame:(CGRectZero)];
        _contentView.backgroundColor = SL_UIColorFromRGBandAlpha(0xFFFFFF, 0.95);
        
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 8.f;
    }
    
    return _contentView;
}

- (UILabel *)titleLabel
{

    if (_titleLabel == nil) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _titleLabel.text = @"确定要清空比赛列表吗？";
        _titleLabel.textColor = SL_UIColorFromRGB(0x333333);
        _titleLabel.font = SL_FONT_BOLD(16.f);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLabel;
}

- (UILabel *)describeLabel
{

    if (_describeLabel == nil) {
        
        _describeLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _describeLabel.text = @"非单关比赛，至少选择2场";
        _describeLabel.textColor = SL_UIColorFromRGB(0x999999);
        _describeLabel.font = SL_FONT_SCALE(12.f);
        _describeLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    
    return _describeLabel;
}

- (UIButton *)sureBtn
{

    if (_sureBtn == nil) {
        
        _sureBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _sureBtn.backgroundColor = SL_UIColorFromRGB(0xE63222);
        
        [_sureBtn setTitle:@"确定" forState:(UIControlStateNormal)];
        [_sureBtn setTitleColor:SL_UIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
        
        [_sureBtn setAdjustsImageWhenHighlighted:NO];
        
        _sureBtn.layer.cornerRadius = 4.f;
        
        [_sureBtn addTarget:self action:@selector(sureClick) forControlEvents:(UIControlEventTouchUpInside)];
    }

    return _sureBtn;
}

- (UIButton *)cancelBtn
{

    if (_cancelBtn == nil) {
        
        _cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _cancelBtn.backgroundColor = SL_UIColorFromRGB(0xFFFFFF);
        
        [_cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        [_cancelBtn setTitleColor:SL_UIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        
        [_cancelBtn setAdjustsImageWhenHighlighted:NO];
        
        _cancelBtn.layer.cornerRadius = 4.f;
        _cancelBtn.layer.borderWidth = 1.f;
        _cancelBtn.layer.borderColor = SL_UIColorFromRGB(0xECE5DD).CGColor;
        
        [_cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _cancelBtn;

}

@end
