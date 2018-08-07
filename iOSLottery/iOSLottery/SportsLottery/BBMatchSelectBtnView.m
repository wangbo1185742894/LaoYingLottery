//
//  BBMatchSelectBtnView.m
//  SportsLottery
//
//  Created by 小铭 on 2017/8/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBMatchSelectBtnView.h"
#import "SLConfigMessage.h"

@interface BBMatchSelectBtnView ()

@property (nonatomic, strong) UIButton *leftBtn;

@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation BBMatchSelectBtnView

+ (BBMatchSelectBtnView *)selectBtnViewWithLeftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle
{
    
    BBMatchSelectBtnView *btnView = [[BBMatchSelectBtnView alloc] init];
    
    btnView.leftBtn.titleLabel.text = leftTitle;
    btnView.rightBtn.titleLabel.text = rightTitle;
    
    return btnView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubviews];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = SL__SCALE(2.f);
        self.layer.borderColor = SL_UIColorFromRGB(0xEAE2D9).CGColor;
        self.layer.borderWidth = 1.f;
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)addConstraints
{
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(self.frame.size.width / 2);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.leftBtn.mas_right);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(self.leftBtn.mas_width);
        
    }];

}

- (void)addSubviews
{
    
    [self addSubview:self.leftBtn];
    [self addSubview:self.rightBtn];
    
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    [self addConstraints];
}

#pragma mark --- ButtonClick ---
- (void)buttonClick:(UIButton *)btn
{
    
    NSInteger index = btn.tag - 100;
    if (self.BBMatchSelectBlock) {
        self.BBMatchSelectBlock(index);
    }
}


#pragma mark --- Get Method ---
- (UIButton *)leftBtn
{
    
    if (_leftBtn == nil) {
        
        _leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_leftBtn setTitle:@"全选" forState:(UIControlStateNormal)];
        [_leftBtn setTitleColor:SL_UIColorFromRGB(0x8F6E51) forState:(UIControlStateNormal)];
        _leftBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _leftBtn.titleLabel.font = SL_FONT_SCALE(14);
        [_leftBtn addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _leftBtn.tag = 100 + 1;
    }
    
    return _leftBtn;
}

- (UIButton *)rightBtn
{
    
    if (_rightBtn == nil) {
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:@"清空" forState:(UIControlStateNormal)];
        [_rightBtn setTitleColor:SL_UIColorFromRGB(0x8F6E51) forState:(UIControlStateNormal)];
        _rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _rightBtn.titleLabel.font = SL_FONT_SCALE(14);
        [_rightBtn addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _rightBtn.tag = 100 + 2;
    }
    
    return _rightBtn;
}

- (void)drawRect:(CGRect)rect
{
    
    UIColor *color = SL_UIColorFromRGB(0XECE5DD);
    [color set]; //设置线条颜色
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(rect.size.width / 2, SL__SCALE(10))];
    [path addLineToPoint:CGPointMake(rect.size.width / 2, SL__SCALE(30))];
    
    path.lineWidth = 0.5;
    path.lineCapStyle = kCGLineCapRound; //线条拐角
    path.lineJoinStyle = kCGLineJoinRound; //终点处理
    
    [path stroke];//渲染到图层
    
}

@end
