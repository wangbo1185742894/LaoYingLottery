//
//  CLBetDetailsTopView.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/11/14.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLBetDetailsTopView.h"
#import "CLConfigMessage.h"
#import "CLTools.h"

@interface CLBetDetailsTopView ()

/**
 自选按钮
 */
@property (nonatomic, strong) UIButton *optionalButton;

/**
 随机按钮
 */
@property (nonatomic, strong) UIButton *randomButton;

/**
 清空列表按钮
 */
@property (nonatomic, strong) UIButton *clearButton;


@end

@implementation CLBetDetailsTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
  
    if (self) {
        
        [self p_addSubviews];
        [self p_addConstraints];
    }
    return self;
}

- (void)p_addSubviews
{
    [self addSubview:self.optionalButton];
    [self addSubview:self.randomButton];
    [self addSubview:self.clearButton];
}

- (void)p_addConstraints
{
    [self.optionalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(CL__SCALE(11.f));
        make.top.equalTo(self).offset(CL__SCALE(12.f));
        make.height.mas_equalTo(CL__SCALE(35.f));
        make.width.mas_equalTo(CL__SCALE(110.f));
        make.bottom.equalTo(self).offset(CL__SCALE(-14.f));
    }];
    
    [self.randomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.optionalButton.mas_right).offset(CL__SCALE(12.f));
        make.centerY.width.height.equalTo(self.optionalButton);
    }];
    
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.randomButton.mas_right).offset(CL__SCALE(12.f));
        make.centerY.width.height.equalTo(self.optionalButton);
        make.right.equalTo(self).offset(CL__SCALE(- 10.f));
    }];
    
}

- (void)returnOptionalButtonBlock:(CLBetDetailsTopViewBlock)block
{
    self.optionalBlock = block;
}

- (void)returnRandomButtonBlock:(CLBetDetailsTopViewBlock)block
{
    self.randomBlock = block;
}

- (void)returnClearButtonBlock:(CLBetDetailsTopViewBlock)block
{
    self.clearBlock = block;
}

#pragma mark ----- 按钮点击事件 -----
- (void)optionalButtonOnClick:(UIButton *)btn
{
    self.optionalBlock ? self.optionalBlock() : nil;
}

- (void)randomButtonOnClick:(UIButton *)btn
{
    self.randomBlock ? self.randomBlock() : nil;
}

- (void)clearButtonOnClick:(UIButton *)btn
{
    self.clearBlock ? self.clearBlock() : nil;
}

#pragma mark ----- lazyLoad -----
- (UIButton *)optionalButton{
    
    if (!_optionalButton) {
        
        _optionalButton = [self p_createButtonWithText:@"自选号码" imageName:@"lotteryDetailAdd.png" target:self action:@selector(optionalButtonOnClick:)];
    }
    return _optionalButton;
}
- (UIButton *)randomButton{
    
    if (!_randomButton) {
        
        _randomButton = [self p_createButtonWithText:@"机选一注" imageName:@"lotteryDetailAdd.png" target:self action:@selector(randomButtonOnClick:)];
    }
    return _randomButton;
}
- (UIButton *)clearButton{
    
    if (!_clearButton) {
    
        _clearButton = [self p_createButtonWithText:@"清空列表" imageName:@"lotteryBetDetailTrash.png" target:self action:@selector(clearButtonOnClick:)];
    }
    return _clearButton;
}

- (UIButton *)p_createButtonWithText:(NSString *)str
                           imageName:(NSString *)image
                              target:(id)target
                              action:(SEL)action

{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    [btn setTitle:str forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
    btn.titleLabel.font = FONT_SCALE(13);
    [btn setBackgroundImage:[CLTools createImageWithColor:UIColorFromRGB(0xffffff)] forState:UIControlStateNormal];
    [btn setBackgroundImage:[CLTools createImageWithColor:UIColorFromRGB(0xeeeee5)] forState:UIControlStateHighlighted];
    btn.adjustsImageWhenHighlighted = YES;
    btn.layer.cornerRadius = 2.f;
    btn.layer.borderColor = UIColorFromRGB(0xdddddd).CGColor;
    btn.layer.borderWidth = .5f;
    btn.layer.masksToBounds = YES;
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10.f)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10.f, 0, 0)];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

@end
