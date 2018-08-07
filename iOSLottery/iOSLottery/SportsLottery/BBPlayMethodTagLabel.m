//
//  BBPlayMethodTagLabel.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBPlayMethodTagLabel.h"
#import "SLConfigMessage.h"

@interface BBPlayMethodTagLabel ()

@property (nonatomic, strong) UIImageView *tagImage;

@property (nonatomic, strong) UIView *leftLineView;

@property (nonatomic, strong) UIView *topLineView;

@property (nonatomic, strong) UIView *buttomLineView;

@end

@implementation BBPlayMethodTagLabel

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
       
        [self addSubview:self.tagImage];
        
        self.tagImage.frame = CGRectMake(0, 0, SL__SCALE(20.f), SL__SCALE(20.f));
        
        [self addSubview:self.leftLineView];
        [self addSubview:self.topLineView];
        [self addSubview:self.buttomLineView];
        
        self.font = SL_FONT_SCALE(10.f);
        self.textColor = SL_UIColorFromRGB(0x999999);
        self.textAlignment = NSTextAlignmentCenter;
        
        self.backgroundColor = SL_UIColorFromRGB(0xffffff);
        
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews
{

    [super layoutSubviews];
    
    self.buttomLineView.frame = CGRectMake(0, self.frame.size.height - .51, self.frame.size.width, .51);
}

- (void)setTagText:(NSString *)text
{
    
    self.text = text;
}

- (void)setTagTextColor:(UIColor *)textColor
{
    
    self.textColor = textColor;
}

- (void)setShowTag:(BOOL)show
{
    self.tagImage.hidden = !show;
}

- (void)setShowButtomLine:(BOOL)show
{

    self.buttomLineView.hidden = !show;
}


#pragma mark --- lazyLoad ----

- (UIImageView *)tagImage
{

    if (_tagImage == nil) {
        
        _tagImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play_danguan"]];
        
        _tagImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _tagImage;
}


- (UIView *)leftLineView
{

    if (_leftLineView == nil) {
        
        _leftLineView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, SL__SCALE(40.f), 0.51f))];
        _leftLineView.backgroundColor = SL_UIColorFromRGB(0xece5dd);
    }
    return _leftLineView;
}

- (UIView *)topLineView
{
    
    if (_topLineView == nil) {
        
        _topLineView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 0.51f, SL__SCALE(40.f)))];
        _topLineView.backgroundColor = SL_UIColorFromRGB(0xece5dd);
    }
    return _topLineView;
}

- (UIView *)buttomLineView
{
    
    if (_buttomLineView == nil) {
        
        _buttomLineView = [[UIView alloc] init];
        _buttomLineView.backgroundColor = SL_UIColorFromRGB(0xece5dd);
        
        _buttomLineView.hidden = YES;
    }
    return _buttomLineView;
}


@end
