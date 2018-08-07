//
//  UILabel+SLAttributeLabel.h
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/23.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (SLAttributeLabel)

- (void)sl_attributeWithText:(NSString*)text controParams:(NSArray* )params;

- (void)sl_attributeWithText:(NSString *)text beginTag:(NSString *)beginTag endTag:(NSString *)endTag color:(UIColor *)color;

@end

@interface SLAttributedTextParams : NSObject

@property (nonatomic, assign)NSRange range;
@property (nonatomic, strong)UIColor *color;
@property (nonatomic, strong)UIFont* font;
@property (nonatomic, strong)NSString *linkName;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, assign) NSTextAlignment cqTextAligment;

@property (nonatomic, strong)NSTextAttachment *attachment;
//指定位置 颜色 字号
+ (SLAttributedTextParams*)attributeRange:(NSRange)ra Color:(UIColor *)co Font:(UIFont*)fo;
//指定位置 颜色
+ (SLAttributedTextParams*)attributeRange:(NSRange)ra Color:(UIColor *)co;
//指定位置 字号
+ (SLAttributedTextParams*)attributeRange:(NSRange)ra Font:(UIFont*)fo;
//指定位置 颜色 字体属性（插入图片等）
+ (SLAttributedTextParams*)attributeStringWithAttachment:(NSTextAttachment *)attachment Range:(NSRange)ra Color:(UIColor*)co;
//指定位置 颜色 字号 超链接
+ (SLAttributedTextParams*)attributeRange:(NSRange)ra Color:(UIColor *)co Font:(UIFont *)fo link:(NSString *)link_name;
//指定位置 行间距 文字居中
+ (SLAttributedTextParams *)attributeRange:(NSRange)ra lineSpacing:(CGFloat)lineSpacing textAligment:(NSTextAlignment)textAligment;

@end

