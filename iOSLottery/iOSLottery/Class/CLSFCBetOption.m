//
//  CLSFCBetOption.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/26.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLSFCBetOption.h"

#import "CLConfigMessage.h"

#import "UIImage+SLImage.h"

@interface CLSFCBetOption ()


@property (nonatomic, strong) UIView *leftLineView;

@property (nonatomic, strong) UIView *rightLineView;

@property (nonatomic, strong) UIView *topLineView;

@property (nonatomic, strong) UIView *buttomLineView;

@end

@implementation CLSFCBetOption


- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        
        [self setBackgroundImage:[UIImage sl_imageWithColor:UIColorFromRGB(0xffffff)] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage sl_imageWithColor:UIColorFromRGB(0xe63222)] forState:UIControlStateSelected];
        
        self.adjustsImageWhenHighlighted = NO;
        
        [self setTitleColor:UIColorFromRGB(0x33333) forState:(UIControlStateNormal)];
        
        [self addSubview:self.leftLineView];
        [self addSubview:self.topLineView];
        [self addSubview:self.rightLineView];
        [self addSubview:self.buttomLineView];
        
    }
    return self;
    
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    self.topLineView.frame = CGRectMake(0, 0, self.frame.size.width, 0.51f);
    
    self.leftLineView.frame =  CGRectMake(0, 0, 0.51f, self.frame.size.height);
    
    self.rightLineView.frame = CGRectMake(self.frame.size.width - .51, 0, .51f, self.frame.size.height);
    
    self.buttomLineView.frame = CGRectMake(0, self.frame.size.height - .51f, self.frame.size.width, 0.51f);
}

- (void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];
    
    if (selected) {
        
        [self setTitleColor:UIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
        
    }else{
    
    
        [self setTitleColor:UIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        
    }
}

- (void)setPlayName:(NSString *)str
{
    [self setTitle:str forState:(UIControlStateNormal)];
}

- (void)setNormalColor:(UIColor *)color
{

    [self setBackgroundImage:[UIImage sl_imageWithColor:color] forState:UIControlStateNormal];
}

- (void)setShowLeftLine:(BOOL)showLeftLine
{
    
    self.topLineView.hidden = !showLeftLine;
}

- (void)setShowTopLine:(BOOL)showTopLine
{
    
    self.topLineView.hidden = !showTopLine;
}

- (void)setShowRightLine:(BOOL)showRightLine
{
    
    self.rightLineView.hidden = !showRightLine;
}

- (void)setShowBottomLine:(BOOL)showBottomLine
{
    self.buttomLineView.hidden = !showBottomLine;
}

#pragma mark ---- lazyLoad ----

- (UIView *)leftLineView
{
    
    if (_leftLineView == nil) {
        
        _leftLineView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, CL__SCALE(40.f), 0.51f))];
        _leftLineView.backgroundColor = UIColorFromRGB(0xece5dd);
    }
    return _leftLineView;
    
}

- (UIView *)rightLineView
{
    
    if (_rightLineView == nil) {
        
        _rightLineView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, CL__SCALE(40.f), 0.51f))];
        _rightLineView.backgroundColor = UIColorFromRGB(0xece5dd);
        
        _rightLineView.hidden = YES;
    }
    return _rightLineView;
    
}

- (UIView *)topLineView
{
    
    if (_topLineView == nil) {
        
        _topLineView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, CL__SCALE(40.f), 0.51f))];
        _topLineView.backgroundColor = UIColorFromRGB(0xece5dd);
    }
    return _topLineView;
    
}

- (UIView *)buttomLineView
{
    
    if (_buttomLineView == nil) {
        
        _buttomLineView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, CL__SCALE(40.f), 0.51f))];
        _buttomLineView.backgroundColor = UIColorFromRGB(0xece5dd);
        
        _buttomLineView.hidden = YES;
    }
    return _buttomLineView;
    
}


@end
