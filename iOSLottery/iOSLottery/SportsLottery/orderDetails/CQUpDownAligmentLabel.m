//
//  CQUpDownAligmentLabel.m
//  caiqr
//
//  Created by huangyuchen on 16/7/23.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CQUpDownAligmentLabel.h"

@implementation CQUpDownAligmentLabel

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.verticalAlignmentType = CQVerticalAlignmentTypeMiddle;
    }
    return self;
}
#pragma mark - 设置行间距方法
- (void)installLineSpacingWithSpacing:(CGFloat)lineSpacing{
    
    NSString *text = self.text;
    if (!(text && text.length > 0)) return;
    //创建NSMutableAttributedString实例，并将text传入
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:text];
    //创建NSMutableParagraphStyle实例
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    //设置行距
    [style setLineSpacing:lineSpacing];
    [style setAlignment:self.horizontalAlignmentType];
    //判断内容长度是否大于Label内容宽度，如果不大于，则设置内容宽度为行宽（内容如果小于行宽，Label长度太短，如果Label有背景颜色，将影响布局效果）
    NSInteger leng = self.bounds.size.width;
    if (attStr.length < self.bounds.size.width) {
        leng = attStr.length;
    }
    //根据给定长度与style设置attStr式样
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, leng)];
    //Label获取attStr式样
    self.attributedText = attStr;
}

#pragma mark - setterMothed
- (void)setText:(NSString *)text{
    [super setText:text];
    //设置text的时候重设一遍行间距
    if (self.labelLineSpacing > 0) {
        [self installLineSpacingWithSpacing:self.labelLineSpacing];
    }
}
//设置行间距
- (void)setLabelLineSpacing:(CGFloat)labelLineSpacing{
    _labelLineSpacing = labelLineSpacing;
    //校验合法性
    if (_labelLineSpacing > 0) {
        [self installLineSpacingWithSpacing:_labelLineSpacing];
    }
}
//设置对齐方式
- (void)setVerticalAlignmentType:(CQVerticalAlignmentType)verticalAlignmentType{
    _verticalAlignmentType = verticalAlignmentType;
    [self setNeedsDisplay];
}
//设置text位置
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.verticalAlignmentType) {
        case CQVerticalAlignmentTypeTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case CQVerticalAlignmentTypeBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        case CQVerticalAlignmentTypeMiddle:
            // Fall through.
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    return textRect;
}
//重写  设置文字的位置
-(void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}

@end
