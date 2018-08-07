//
//  SLMatchSelectBtnView.m
//  赛事筛选
//
//  Created by 任鹏杰 on 2017/5/9.
//  Copyright © 2017年 任鹏杰. All rights reserved.
//

#import "SLMatchSelectBtnView.h"
#import "SLConfigMessage.h"

@interface SLMatchSelectBtnView ()

@property (nonatomic, strong) UIButton *leftBtn;

@property (nonatomic, strong) UIButton *middleBtn;

@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation SLMatchSelectBtnView

+ (instancetype)selectBtnViewWithLeftTitle:(NSString *)leftTitle middleTitle:(NSString *)middleTitle rightTitle:(NSString *)rightTitle
{

    SLMatchSelectBtnView *btnView = [[SLMatchSelectBtnView alloc] init];

    btnView.leftBtn.titleLabel.text = leftTitle;
    btnView.middleBtn.titleLabel.text = middleTitle;
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
        make.width.mas_equalTo(self.frame.size.width / 3);
    }];
    
    [self.middleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.leftBtn.mas_right);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(self.leftBtn.mas_width);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.middleBtn.mas_right);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(self.leftBtn.mas_width);
        
    }];
    

}

- (void)addSubviews
{

    [self addSubview:self.leftBtn];
    [self addSubview:self.middleBtn];
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

    if ([self.delegate respondsToSelector:@selector(selectBtnAtIndex:)]) {
        
        [self.delegate selectBtnAtIndex:index];
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

- (UIButton *)middleBtn
{

    if (_middleBtn == nil) {
        
        _middleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_middleBtn setTitle:@"仅五大联赛" forState:(UIControlStateNormal)];
        [_middleBtn setTitleColor:SL_UIColorFromRGB(0x8F6E51) forState:(UIControlStateNormal)];
        _middleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _middleBtn.titleLabel.font = SL_FONT_SCALE(14);
        [_middleBtn addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _middleBtn.tag = 100 + 2;
    }

    return _middleBtn;
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
        _rightBtn.tag = 100 + 3;
    }
    
    return _rightBtn;
}

- (void)drawRect:(CGRect)rect
{

    UIColor *color = SL_UIColorFromRGB(0XECE5DD);
    [color set]; //设置线条颜色
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(rect.size.width / 3, SL__SCALE(10))];
    [path addLineToPoint:CGPointMake(rect.size.width / 3, SL__SCALE(30))];
    
    [path moveToPoint:CGPointMake(rect.size.width / 3 * 2, SL__SCALE(10))];
    [path addLineToPoint:CGPointMake(rect.size.width / 3 * 2, SL__SCALE(30))];
    
    path.lineWidth = 0.5;
    path.lineCapStyle = kCGLineCapRound; //线条拐角
    path.lineJoinStyle = kCGLineJoinRound; //终点处理
    
    [path stroke];//渲染到图层

}

@end
