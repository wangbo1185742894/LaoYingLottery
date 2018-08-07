//
//  BBNoSaleLabel.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/16.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBNoSaleLabel.h"

#import "SLConfigMessage.h"

@interface BBNoSaleLabel ()

@property (nonatomic, strong) UIView *topLine;

@property (nonatomic, strong) UIView *leftLine;

@property (nonatomic, strong) UIView *rightLine;

@property (nonatomic, strong) UIView *buttomLine;

@end

@implementation BBNoSaleLabel

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
    
        
        self.font =SL_FONT_SCALE(12.f);
        self.textColor = SL_UIColorFromRGB(0x999999);
        
        self.text = @"未开售";
        
        self.textAlignment = NSTextAlignmentCenter;
        
        self.backgroundColor = SL_UIColorFromRGB(0xFFFFFF);
        
        self.userInteractionEnabled = YES;
        
        self.clipsToBounds = YES;
        
        [self addSubview:self.topLine];
        [self addSubview:self.leftLine];
        [self addSubview:self.rightLine];
        [self addSubview:self.buttomLine];
    }
    return self;
}

- (void)layoutSubviews
{

    [super layoutSubviews];
    
    self.topLine.frame = CGRectMake(0, 0, self.frame.size.width, 0.51);
    self.leftLine.frame = CGRectMake(0, 0, .51f, self.frame.size.height);
    self.rightLine.frame = CGRectMake(self.frame.size.width - 0.51, 0, 0.51, self.frame.size.height);
    self.buttomLine.frame = CGRectMake(0, self.frame.size.height - .51f, self.frame.size.width, 0.51);
}

- (void)showButtomLine:(BOOL)show
{

    self.buttomLine.hidden = !show;
}

- (UIView *)leftLine
{
    
    if (_leftLine == nil) {
        
        _leftLine = [[UIView alloc] initWithFrame:CGRectZero];
        _leftLine.backgroundColor = SL_UIColorFromRGB(0xece5dd);
    }
    return _leftLine;
    
}

- (UIView *)rightLine
{
    
    if (_rightLine == nil) {
        
        _rightLine = [[UIView alloc] initWithFrame:CGRectZero];
        _rightLine.backgroundColor = SL_UIColorFromRGB(0xece5dd);
    }
    return _rightLine;
    
}

- (UIView *)topLine
{
    
    if (_topLine == nil) {
        
        _topLine = [[UIView alloc] initWithFrame:CGRectZero];
        _topLine.backgroundColor = SL_UIColorFromRGB(0xece5dd);
    }
    return _topLine;
    
}

- (UIView *)buttomLine
{
    
    if (_buttomLine == nil) {
        
        _buttomLine = [[UIView alloc] initWithFrame:CGRectZero];
        _buttomLine.backgroundColor = SL_UIColorFromRGB(0xece5dd);

    }
    return _buttomLine;
    
}

@end
