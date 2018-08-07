//
//  UILabel+CKAttributeLabel.h
//  caiqr
//
//  Created by huangyuchen on 2017/5/4.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (CKAttributeLabel)

- (void)ck_attributeWithText:(NSString*)text controParams:(NSArray* )params;

@end

@interface CKAttributedTextParams : NSObject

@property (nonatomic, assign)NSRange range;
@property (nonatomic, strong)UIColor *color;
@property (nonatomic, strong)UIFont* font;
@property (nonatomic, strong)NSString *linkName;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, assign) NSTextAlignment cqTextAligment;

@property (nonatomic, strong)NSTextAttachment *attachment;

+ (CKAttributedTextParams*)attributeRange:(NSRange)ra Color:(UIColor *)co Font:(UIFont*)fo;
+ (CKAttributedTextParams*)attributeRange:(NSRange)ra Color:(UIColor *)co;
+ (CKAttributedTextParams*)attributeRange:(NSRange)ra Font:(UIFont*)fo;
+ (CKAttributedTextParams*)attributeStringWithAttachment:(NSTextAttachment *)attachment Range:(NSRange)ra Color:(UIColor*)co;
+ (CKAttributedTextParams*)attributeRange:(NSRange)ra Color:(UIColor *)co Font:(UIFont *)fo link:(NSString *)link_name;
+ (CKAttributedTextParams *)attributeRange:(NSRange)ra lineSpacing:(CGFloat)lineSpacing textAligment:(NSTextAlignment)textAligment;






@end
