//
//  UILabel+CLAttributeLabel.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/15.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (CLAttributeLabel)

- (void)attributeWithText:(NSString*)text controParams:(NSArray* )params;

- (void)attributeWithText:(NSString *)text beginTag:(NSString *)beginTag endTag:(NSString *)endTag color:(UIColor *)color;
@end

@interface AttributedTextParams : NSObject

@property (nonatomic, assign)NSRange range;
@property (nonatomic, strong)UIColor *color;
@property (nonatomic, strong)UIFont* font;
@property (nonatomic, strong)NSString *linkName;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, assign) NSTextAlignment cqTextAligment;

@property (nonatomic, strong)NSTextAttachment *attachment;
//指定位置 颜色 字号
+ (AttributedTextParams*)attributeRange:(NSRange)ra Color:(UIColor *)co Font:(UIFont*)fo;
//指定位置 颜色
+ (AttributedTextParams*)attributeRange:(NSRange)ra Color:(UIColor *)co;
//指定位置 字号
+ (AttributedTextParams*)attributeRange:(NSRange)ra Font:(UIFont*)fo;
//指定位置 颜色 字体属性（插入图片等）
+ (AttributedTextParams*)attributeStringWithAttachment:(NSTextAttachment *)attachment Range:(NSRange)ra Color:(UIColor*)co;
//指定位置 颜色 字号 超链接
+ (AttributedTextParams*)attributeRange:(NSRange)ra Color:(UIColor *)co Font:(UIFont *)fo link:(NSString *)link_name;
//指定位置 行间距 文字居中
+ (AttributedTextParams *)attributeRange:(NSRange)ra lineSpacing:(CGFloat)lineSpacing textAligment:(NSTextAlignment)textAligment;

@end
