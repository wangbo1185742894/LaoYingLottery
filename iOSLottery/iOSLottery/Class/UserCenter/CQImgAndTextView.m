//
//  CQImgAndTextView.m
//  caiqr
//
//  Created by 彩球 on 16/4/8.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CQImgAndTextView.h"
#import "CLConfigMessage.h"

@interface CQImgAndTextView ()

@property (nonatomic, strong) UIImageView* imgView;

@property (nonatomic, strong) UILabel* textLable;

@end

@implementation CQImgAndTextView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imgTextAlignment = CQImgTextAlignmentCenter;
        _imgToHeightScale = .3f;
        _textToHeightScale = .5f;
        _imgAndTextSpacing = 5.f;
        _leftSpacing = 0.f;
        _rightSpacing = 0.f;
        _titleFont = FONT_SCALE(12.f);
        
        self.backgroundColor = UIColorFromRGB(0xffffff);
        [self addSubview:self.imgView];
        [self addSubview:self.textLable];
        
        [self resetFrame];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked:)];
        [self addGestureRecognizer:tap];
        self.userInteractionEnabled  = YES;
        
    }
    return self;
}

- (void)setImgTextAlignment:(CQImgTextAlignment)imgTextAlignment
{
    _imgTextAlignment = imgTextAlignment;
    [self resetFrame];
}

- (void)setImgToHeightScale:(CGFloat)imgToHeightScale
{
    _imgToHeightScale = ((imgToHeightScale > 1)?1:imgToHeightScale);
    [self resetFrame];
}

- (void)setTextToHeightScale:(CGFloat)textToHeightScale
{
    
    _textToHeightScale = ((textToHeightScale > 1)?1:textToHeightScale);
    [self resetFrame];
}

- (void)setImgAndTextSpacing:(CGFloat)imgAndTextSpacing
{
    _imgAndTextSpacing = imgAndTextSpacing;
    [self resetFrame];
}

- (void)setLeftSpacing:(CGFloat)leftSpacing
{
    _leftSpacing = leftSpacing;
    [self resetFrame];
}

- (void)setRightSpacing:(CGFloat)rightSpacing
{
    _rightSpacing = rightSpacing;
    [self resetFrame];
}

- (void)setTitle:(NSString *)title
{
    self.textLable.text = title;
    [self resetFrame];
}

- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    self.textLable.font = titleFont;
    [self resetFrame];
}

- (void)setTitleColor:(UIColor *)titleColor
{
    self.textLable.textColor = titleColor;
}

- (void)setImg:(UIImage *)img
{
    self.imgView.image = img;
}

- (void)setCanClick:(BOOL)canClick
{
    _canClick = canClick;
    self.userInteractionEnabled = _canClick;
}

- (void)setImgUrl:(NSString *)imgUrl placeholder:(UIImage*)img
{
//    [CQTools cq_setImageSetWith:self.imgView Url:[NSURL URLWithString:imgUrl] placeholder:img];
}

- (void)resetFrame
{
    CGFloat imgHeight = _imgToHeightScale * __Obj_Bounds_Height(self);
    CGFloat textHeight = _textToHeightScale * __Obj_Bounds_Height(self);
    
//    @{};
    
    NSDictionary* dict = @{NSFontAttributeName : self.textLable.font};
    
    
    CGFloat textWidth = [self.textLable.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.width;
    
    CGFloat availableWidth = imgHeight + ((textWidth == 0)?0:(textWidth + _imgAndTextSpacing));
    
    
    if (_imgTextAlignment == CQImgTextAlignmentCenter) {
        self.imgView.frame = __Rect((__Obj_Bounds_Width(self) - availableWidth) / 2.f, (__Obj_Bounds_Height(self) - imgHeight) / 2.f, imgHeight, imgHeight);
        self.textLable.frame = __Rect(__Obj_XW_Value(self.imgView) + _imgAndTextSpacing, (__Obj_Bounds_Height(self) - textHeight) / 2.f, textWidth, textHeight);
    }
    else if (_imgTextAlignment == CQImgTextAlignmentLeft)
    {
        self.imgView.frame = __Rect(_leftSpacing, (__Obj_Bounds_Height(self) - imgHeight) / 2.f, imgHeight, imgHeight);
        self.textLable.frame = __Rect(__Obj_XW_Value(self.imgView) + _imgAndTextSpacing, (__Obj_Bounds_Height(self) - textHeight) / 2.f, textWidth, textHeight);
    }
    else if (_imgTextAlignment == CQImgTextAlignmentRight)
    {
        self.textLable.frame = __Rect(__Obj_Bounds_Width(self) - textWidth - _rightSpacing, (__Obj_Bounds_Height(self) - textHeight) / 2.f, textWidth, textHeight);
        self.imgView.frame = __Rect(__Obj_Frame_X(self.textLable) - _imgAndTextSpacing - imgHeight, (__Obj_Bounds_Height(self) - imgHeight) / 2.f, imgHeight, imgHeight);
        
    }
    
}

- (void)tapClicked:(id)sender
{
    if (self.tapGestureHandler) {
        self.tapGestureHandler();
    }
}


#pragma mark - getter

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:__Rect(0, 0, 15, 15)];
//        _imgView = [[UIImageView alloc] initWithFrame:__Rect(0, 0, self.imgToHeightScale * __Obj_Bounds_Height(self), self.imgToHeightScale * __Obj_Bounds_Height(self))];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgView;
}

- (UILabel *)textLable
{
    if (!_textLable) {
        AllocNormalLabel(_textLable, @"", _titleFont, NSTextAlignmentLeft, UIColorFromRGB(0x333333), __Rect(0, 0, 1, 1))
    }
    return _textLable;
    
}

@end
