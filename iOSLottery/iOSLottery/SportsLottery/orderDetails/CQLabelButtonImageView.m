//
//  CQLabelButtonImageView.m
//  caiqr
//
//  Created by huangyuchen on 16/8/7.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CQLabelButtonImageView.h"
#import "CQDefinition.h"
#import "SLConfigMessage.h"
#import "CQUpDownAligmentLabel.h"
#import "NSString+SLString.h"
@interface CQLabelButtonImageView ()

@property (nonatomic, strong) CQUpDownAligmentLabel *contentLabel;
@property (nonatomic, strong) UIButton *contentButton;
@property (nonatomic, strong) UIImageView *contentImageView;

@end

@implementation CQLabelButtonImageView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.contentLabel];
        [self addSubview:self.contentButton];
        [self addSubview:self.contentImageView];
    }
    return self;
}
#pragma mark - button点击事件
- (void)btnOnClick:(UIButton *)btn{
    if (self.contentBtnBlock) {
        self.contentBtnBlock();
    }
}
#pragma mark - 计算相应文字的宽度 高度
- (CGSize)calculateTextWidth:(NSString *)text{    
    CGSize size =  [text boundingRectFontOptionWithSize:CGSizeMake(CGFLOAT_MAX,self.bounds.size.height) Font:FONT_FIX(12)].size;
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}

#pragma mark - setterMothed
- (void)setLabelText:(NSString *)labelText{
    
    _labelText = labelText;
    
    if (_labelText && _labelText.length > 0) {
        
        self.contentLabel.text = _labelText;
        
        CGFloat width = [self calculateTextWidth:_labelText].width;
        CGFloat height = [self calculateTextWidth:_labelText].height;
        //更新frame
        self.contentLabel.frame = CGRectMake(0, 0, width, CGRectGetHeight(self.frame));
        self.contentButton.frame = CGRectMake(CGRectGetMaxX(self.contentLabel.frame) + __SCALE(4.f), CGRectGetMinY(self.contentLabel.frame), 0, CGRectGetHeight(self.contentLabel.frame));
        
        self.contentImageView.frame = CGRectMake(CGRectGetMaxX(self.contentButton.frame) + __SCALE(1.f), CGRectGetMinY(self.contentButton.frame), height,height);
    }
}

- (void)setLabelTextFont:(UIFont *)labelTextFont
{

    _labelTextFont = labelTextFont;
    
    self.contentLabel.font = labelTextFont;
}

- (void)setButtonText:(NSString *)buttonText{
    
    _buttonText = buttonText;
    
    if (_buttonText && _buttonText.length > 0) {
        
        [self.contentButton setTitle:_buttonText forState:UIControlStateNormal];
        
        CGFloat width = [self calculateTextWidth:_buttonText].width;
        CGFloat height = [self calculateTextWidth:_buttonText].height;
        //更新frame
        if (CGRectGetMaxX(self.contentLabel.frame) == 0) {
            
            self.contentButton.frame = CGRectMake(0, 0, width, height);
            
        }else{
            
            self.contentButton.frame = CGRectMake(CGRectGetMaxX(self.contentLabel.frame) + __SCALE(3.f), CGRectGetMinY(self.contentLabel.frame), width, CGRectGetHeight(self.contentLabel.frame));
        }
        self.contentImageView.frame = CGRectMake(CGRectGetMaxX(self.contentButton.frame) + __SCALE(1.f), CGRectGetMinY(self.contentButton.frame), height, height);
    }
}

- (void)setButtonTextColor:(UIColor *)buttonTextColor
{
    _buttonTextColor = buttonTextColor;
    
    [self.contentButton setTitleColor:buttonTextColor forState:(UIControlStateNormal)];
}


-(void)setContentButtonHorizontalAlignment:(UIControlContentHorizontalAlignment )contentButtonHorizontalAlignment{
    _contentButtonHorizontalAlignment = contentButtonHorizontalAlignment;
    
    self.contentButton.contentHorizontalAlignment = _contentButtonHorizontalAlignment;
    
}
- (void)setContentImage:(UIImage *)contentImage{
    _contentImage = contentImage;
    if (_contentImage) {
        
        _contentImageView.image = _contentImage;
        
    }
}
#pragma mark - getter Mothed
- (CQUpDownAligmentLabel *)contentLabel{
    if (!_contentLabel) {
        //这里设置label的宽度为0，是因为需要动态计算label的宽度
        _contentLabel = [[CQUpDownAligmentLabel alloc] initWithFrame:CGRectMake(0, 0, 0, CGRectGetHeight(self.frame))];
        _contentLabel.font = SL_FONT_SCALE(12.f);
        _contentLabel.textColor = SL_UIColorFromRGB(0x666666);
        _contentLabel.verticalAlignmentType = CQVerticalAlignmentTypeTop;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _contentLabel;
}

- (UIButton *)contentButton{
    
    if (!_contentButton) {
        _contentButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.contentLabel.frame) + __SCALE(4.f), CGRectGetMinY(self.contentLabel.frame), 0, CGRectGetHeight(self.contentLabel.frame))];
        [_contentButton addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_contentButton setTitleColor:SL_UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        _contentButton.titleLabel.font = SL_FONT_SCALE(12.f);
        _contentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _contentButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    }
    return _contentButton;
}

- (UIImageView *)contentImageView{
    
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.contentButton.frame) + __SCALE(1.f), CGRectGetMinY(self.contentButton.frame), CGRectGetHeight(self.contentButton.frame), CGRectGetHeight(self.contentButton.frame))];
        _contentImageView.contentMode = UIViewContentModeLeft;
    }
    return _contentImageView;
}
@end
