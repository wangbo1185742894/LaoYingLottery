//
//  SLBetDetailsTopView.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/17.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLBetDetailsTopView.h"
#import "SLConfigMessage.h"

@interface SLBetDetailsTopView ()

/**
 编辑按钮
 */
@property (nonatomic, strong) UIButton *editBtn;

/**
 清空按钮
 */
@property (nonatomic, strong) UIButton *emptyBtn;


/**
 已选几场label
 */
@property (nonatomic, strong) UILabel *isSelectLabel;

/**
 底部图片
 */
@property (nonatomic, strong) UIImageView *bottomImage;

@end

@implementation SLBetDetailsTopView

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubviews];
        [self addConstraints];
        self.backgroundColor = SL_UIColorFromRGB(0xfaf8f6);
    }
    
    return self;

}

- (void)addSubviews
{
    
    [self addSubview:self.editBtn];
    [self addSubview:self.emptyBtn];
    [self addSubview:self.isSelectLabel];
    [self addSubview:self.bottomImage];
}

- (void)addConstraints
{

    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(SL__SCALE(15.f));
        make.top.equalTo(self.mas_top).offset(SL__SCALE(16.f));
        make.width.mas_offset(SL__SCALE(165.f));
        make.height.mas_offset(SL__SCALE(30.f));
    }];
    
    [self.emptyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.editBtn.mas_right).offset(SL__SCALE(15.f));
        make.centerY.equalTo(self.editBtn.mas_centerY);
        make.width.height.equalTo(self.editBtn);
        make.right.equalTo(self.mas_right).offset(SL__SCALE(-15.f));
        
    }];
    
    [self.isSelectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.editBtn.mas_bottom).offset(SL__SCALE(17.f));
        make.left.equalTo(self.editBtn.mas_left);
        make.height.mas_offset(SL__SCALE(12.f));
    }];
    
    [self.bottomImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.isSelectLabel.mas_bottom).offset(SL__SCALE(6.f));
        make.left.equalTo(self.mas_left).offset(SL__SCALE(10.f));
        make.right.equalTo(self.mas_right).offset(SL__SCALE(-10.f));
        make.height.mas_offset(SL__SCALE(6.f));
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}

- (void)setIsShowSelectNumber:(BOOL)show
{

    if (show == YES) return;
    
    [self.isSelectLabel mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.height.mas_offset(0);
    }];
    
    self.isSelectLabel.hidden = !show;
}

- (void)setisSelectNumber:(NSInteger)number
{

    self.isSelectLabel.text = [NSString stringWithFormat:@"已选%ld场比赛",number];
}

- (void)returnEditClick:(SLBetDetailsTopBlock)block
{
    _editBlock = block;
}

- (void)returnEmptyClick:(SLBetDetailsTopBlock)block
{
    _emptyBlock = block;
}

#pragma mark --- ButtonClick ---

- (void)editBtnClick
{
    if (self.editBlock) {
        
        self.editBlock();
    }

}

- (void)emptyBtnClick
{

    if (self.emptyBlock) {
        
        self.emptyBlock();
    }
}


#pragma mark --- Get Method ---
- (UIButton *)editBtn
{

    if (_editBtn == nil) {
        
        _editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        [_editBtn setTitle:@"添加/编辑赛事" forState:(UIControlStateNormal)];
        [_editBtn setTitleColor:SL_UIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        [_editBtn setImage:[UIImage imageNamed:@"bet_details_add"] forState:(UIControlStateNormal)];
        
        _editBtn.imageEdgeInsets = UIEdgeInsetsMake(1, SL__SCALE(-5.f), 0, 0);
        [_editBtn setBackgroundColor:SL_UIColorFromRGB(0xFFFFFF)];
        
        _editBtn.layer.borderWidth = 0.5f;
        _editBtn.layer.borderColor = SL_UIColorFromRGB(0xECE5DD).CGColor;
        
        _editBtn.titleLabel.font = SL_FONT_SCALE(14.f);
        [_editBtn setAdjustsImageWhenHighlighted:NO];
        
        [_editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        
    }

    return _editBtn;
}

- (UIButton *)emptyBtn
{

    if (_emptyBtn == nil) {
        
        _emptyBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        [_emptyBtn setTitle:@"清空列表" forState:(UIControlStateNormal)];
        [_emptyBtn setTitleColor:SL_UIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        [_emptyBtn setImage:[UIImage imageNamed:@"bet_details_empty"] forState:(UIControlStateNormal)];
        
        [_emptyBtn setBackgroundColor:SL_UIColorFromRGB(0xFFFFFF)];
        
        _emptyBtn.layer.borderWidth = 0.5f;
        _emptyBtn.layer.borderColor = SL_UIColorFromRGB(0xECE5DD).CGColor;
        
        _emptyBtn.titleLabel.font = SL_FONT_SCALE(14.f);
        [_emptyBtn setAdjustsImageWhenHighlighted:NO];
        
        [_emptyBtn addTarget:self action:@selector(emptyBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        
    
    }
    
    return _emptyBtn;
}

- (UILabel *)isSelectLabel
{

    if (_isSelectLabel == nil) {
        
        _isSelectLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        
        _isSelectLabel.text = @"已选2场";
        _isSelectLabel.textColor = SL_UIColorFromRGB(0x8F6E51);
        _isSelectLabel.textAlignment = NSTextAlignmentCenter;
        _isSelectLabel.font = SL_FONT_SCALE(12.f);
    }
    
    return _isSelectLabel;
}

- (UIImageView *)bottomImage
{

    if (_bottomImage == nil) {
        
        _bottomImage = [[UIImageView alloc] initWithFrame:(CGRectZero)];
        
        _bottomImage.image = [UIImage imageNamed:@"bet_details_exit"];
    }
    
    return _bottomImage;
}

@end
