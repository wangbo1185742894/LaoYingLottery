//
//  CLLotteryNoDataView.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/2/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLLotteryNoDataView.h"
#import "CLConfigMessage.h"
@interface CLLotteryNoDataView ()

@property (nonatomic, strong) UIView *baseView;

@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, strong) UILabel *titleLabel;

@end
@implementation CLLotteryNoDataView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];

        [self p_addSubViews];
        [self p_addConstraints];
    
    }
    return self;
}

- (void)p_addSubViews
{
    
    self.baseView = [[UIView alloc] initWithFrame:CGRectZero];

    [self addSubview:self.baseView];
    [self.baseView addSubview:self.btn];
    [self.baseView addSubview:self.titleLabel];

}

- (void)p_addConstraints
{

    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.baseView);
        make.centerX.equalTo(self);
    }];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleLabel.mas_bottom).offset(CL__SCALE(20.f));
        make.left.right.equalTo(self.baseView);
        make.height.mas_equalTo(CL__SCALE(35.f));
        make.width.mas_equalTo(CL__SCALE(95.f));
        make.bottom.equalTo(self.baseView);
    }];
    
}

- (void)tap:(UITapGestureRecognizer *)tap{
    
    
}
- (void)btnOnClick:(UIButton *)btn{
    
    !self.emptyBtnBlock ? : self.emptyBtnBlock();
}


#pragma mark ----- lazyload ------

- (UILabel *)titleLabel
{

    if (_titleLabel == nil) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.text = @"加载数据失败";
        _titleLabel.textColor = UIColorFromRGB(0x666666);
        _titleLabel.font = CL_FONT_SCALE(14.f);
    }
    return _titleLabel;
}

- (UIButton *)btn
{

    if (_btn == nil) {
       
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setTitle:@"重新加载" forState:UIControlStateNormal];
        [_btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        
        _btn.backgroundColor = THEME_COLOR;
        
        [_btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        _btn.titleLabel.font = FONT_SCALE(13);
        _btn.layer.cornerRadius = 4.f;
        _btn.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
        _btn.layer.borderWidth = 0.5f;

    }
    return _btn;
}

@end
