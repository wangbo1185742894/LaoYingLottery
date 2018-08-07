//
//  BBOddsItemButton.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/7.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBOddsItemButton.h"
#import "SLConfigMessage.h"

#import "UIImage+SLImage.h"

#import "BBMatchInfoManager.h"
#import "UILabel+SLAttributeLabel.h"
@interface BBOddsItemButton ()

/**
 玩法名label
 */
@property (nonatomic, strong) UILabel *playNameLabel;

/**
 赔率Label
 */
@property (nonatomic, strong) UILabel *oddsLabel;

@property (nonatomic, strong) UIView *leftLineView;

@property (nonatomic, strong) UIView *rightLineView;

@property (nonatomic, strong) UIView *topLineView;

@property (nonatomic, strong) UIView *buttomLineView;

@property (nonatomic, strong) NSArray *attrArr;

@property (nonatomic, strong) NSString *playString;

@end

@implementation BBOddsItemButton


- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubview:self.playNameLabel];
        [self addSubview:self.oddsLabel];
        
        [self setBackgroundImage:[UIImage sl_imageWithColor:SL_UIColorFromRGB(0xffffff)] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage sl_imageWithColor:SL_UIColorFromRGB(0xe63222)] forState:UIControlStateSelected];

        self.adjustsImageWhenHighlighted = NO;
        
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
    
    self.playNameLabel.frame = SL__Rect(0, SL__SCALE(5.f), self.frame.size.width, SL__SCALE(17.f));
    
    self.oddsLabel.frame = SL__Rect(0, CGRectGetMaxY(self.playNameLabel.frame) + SL__SCALE(2.f), self.frame.size.width, SL__SCALE(12.f));
    
    self.topLineView.frame = CGRectMake(0, 0, self.frame.size.width, 0.51f);
    
    self.leftLineView.frame =  CGRectMake(0, 0, 0.51f, self.frame.size.height);
    
    self.rightLineView.frame = CGRectMake(self.frame.size.width - .51, 0, .51f, self.frame.size.height);
    
    self.buttomLineView.frame = CGRectMake(0, self.frame.size.height - .51f, self.frame.size.width, 0.51f);
}

- (void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];
    
    self.playNameLabel.textColor = selected ? SL_UIColorFromRGB(0xffffff) : SL_UIColorFromRGB(0x333333);
    if (self.attrArr && self.attrArr.count > 0) {
        
        if (!selected) {
            [self.playNameLabel sl_attributeWithText:self.playString controParams:self.attrArr];
        }else{
        
            self.playNameLabel.text = self.playString;
        }
        
    }else {
        self.playNameLabel.text = self.playString;
    }
    
    self.oddsLabel.textColor = selected ? SL_UIColorFromRGB(0xffffff) : SL_UIColorFromRGB(0x999999);
    
}

- (void)setPlayName:(NSString *)str
{
    self.playString = str;
    self.attrArr = nil;
}

- (void)setAttributePlayName:(NSString *)str attributeArr:(NSArray *)attributeArr
{
    self.playString = str;
    self.attrArr = attributeArr;
}

- (void)setOdds:(NSString *)str
{
    
    self.oddsLabel.text = str;
}

- (void)setTextColorWithStr:(NSString *)str tag:(NSString *)tag color:(UIColor *)color{
    
    //NSRange zRange = [str rangeOfString:tag];
        
    SLAttributedTextParams *attr = [SLAttributedTextParams attributeRange:NSMakeRange(0,1) Color:color];
    [self.playNameLabel sl_attributeWithText:str controParams:@[attr]];
    
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
- (UILabel *)playNameLabel
{
    if (_playNameLabel == nil) {
        
        _playNameLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _playNameLabel.text = @"主胜";
        _playNameLabel.textColor = SL_UIColorFromRGB(0x333333);
        _playNameLabel.font = SL_FONT_SCALE(14.f);
        _playNameLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    
    return _playNameLabel;
    
}

- (UILabel *)oddsLabel
{
    
    if (_oddsLabel == nil) {
        
        _oddsLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _oddsLabel.text = @"18.88";
        _oddsLabel.textColor = SL_UIColorFromRGB(0x999999);
        _oddsLabel.font = SL_FONT_SCALE(10.f);
        _oddsLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    
    return _oddsLabel;
}

- (UIView *)leftLineView
{

    if (_leftLineView == nil) {
        
        _leftLineView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, SL__SCALE(40.f), 0.51f))];
        _leftLineView.backgroundColor = SL_UIColorFromRGB(0xece5dd);
    }
    return _leftLineView;
    
}

- (UIView *)rightLineView
{
    
    if (_rightLineView == nil) {
        
        _rightLineView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, SL__SCALE(40.f), 0.51f))];
        _rightLineView.backgroundColor = SL_UIColorFromRGB(0xece5dd);
        
        _rightLineView.hidden = YES;
    }
    return _rightLineView;
    
}

- (UIView *)topLineView
{
    
    if (_topLineView == nil) {
        
        _topLineView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, SL__SCALE(40.f), 0.51f))];
        _topLineView.backgroundColor = SL_UIColorFromRGB(0xece5dd);
    }
    return _topLineView;
    
}

- (UIView *)buttomLineView
{
    
    if (_buttomLineView == nil) {
        
        _buttomLineView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, SL__SCALE(40.f), 0.51f))];
        _buttomLineView.backgroundColor = SL_UIColorFromRGB(0xece5dd);
        
        _buttomLineView.hidden = YES;
    }
    return _buttomLineView;
    
}



@end
