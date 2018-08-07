//
//  UILabel+CKAttributeLabel.m
//  caiqr
//
//  Created by huangyuchen on 2017/5/4.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "UILabel+CKAttributeLabel.h"

@implementation UILabel (CKAttributeLabel)

- (void)ck_attributeWithText:(NSString*)text controParams:(NSArray* )params
{
    @autoreleasepool {
        NSMutableAttributedString* attributedStr = [[NSMutableAttributedString alloc] initWithString:text];
        if (!text || [text isKindOfClass:[NSNull class]] || ![text isKindOfClass:NSString.class] || text.length == 0 || [text isEqualToString:@"(null)"]) return;
        [params enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[CKAttributedTextParams class]]) {
                CKAttributedTextParams* attributeParam = (CKAttributedTextParams*)obj;
                if (attributeParam.range.location != NSNotFound)
                {
                    if (attributeParam.color)
                    {
                        [attributedStr addAttribute:NSForegroundColorAttributeName value:attributeParam.color range:attributeParam.range];
                    }
                    if (attributeParam.font)
                    {
                        [attributedStr addAttribute:NSFontAttributeName value:attributeParam.font range:attributeParam.range];
                    }
                    if (attributeParam.attachment)
                    {
                        [attributedStr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attributeParam.attachment]];
                    }
                    if (attributeParam.linkName)
                    {
                        [attributedStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%@",attributeParam.linkName] range:attributeParam.range];
                    }
                    if (attributeParam.lineSpacing > 0) {
                        //创建NSMutableParagraphStyle实例
                        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
                        //设置行距
                        [style setLineSpacing:attributeParam.lineSpacing];
                        [style setAlignment:attributeParam.cqTextAligment];
                        //根据给定长度与style设置attStr式样
                        [attributedStr addAttribute:NSParagraphStyleAttributeName value:style range:attributeParam.range];
                    }
                }
            }
        }];
        self.attributedText = attributedStr;
    }
}

@end

@implementation CKAttributedTextParams

+ (CKAttributedTextParams*)attributeRange:(NSRange)ra Color:(UIColor *)co Font:(UIFont*)fo
{
    CKAttributedTextParams* attr = [[CKAttributedTextParams alloc] init];
    attr.range = ra;
    attr.color = co;
    attr.font = fo;
    return attr;
    
}

+ (CKAttributedTextParams*)attributeRange:(NSRange)ra Color:(UIColor *)co
{
    CKAttributedTextParams* attr = [[CKAttributedTextParams alloc] init];
    attr.range = ra;
    attr.color = co;
    return attr;
}

+ (CKAttributedTextParams*)attributeRange:(NSRange)ra Font:(UIFont*)fo
{
    CKAttributedTextParams* attr = [[CKAttributedTextParams alloc] init];
    attr.range = ra;
    attr.font = fo;
    return attr;
    
}

+ (CKAttributedTextParams*)attributeStringWithAttachment:(NSTextAttachment *)attachment Range:(NSRange)ra Color:(UIColor *)co
{
    CKAttributedTextParams* attr = [[CKAttributedTextParams alloc] init];
    if (attachment.image == nil) {
        attr.attachment = nil;
    }else{
        attr.attachment = attachment;
    }
    attr.range = ra;
    attr.color = co;
    return attr;
}

+ (CKAttributedTextParams *)attributeRange:(NSRange)ra Color:(UIColor *)co Font:(UIFont *)fo link:(NSString *)link_name
{
    CKAttributedTextParams* attr = [[CKAttributedTextParams alloc] init];
    attr.range = ra;
    attr.color = co;
    attr.font = fo;
    attr.linkName = link_name;
    return attr;
}

+ (CKAttributedTextParams *)attributeRange:(NSRange)ra lineSpacing:(CGFloat)lineSpacing textAligment:(NSTextAlignment)textAligment{
    CKAttributedTextParams* attr = [[CKAttributedTextParams alloc] init];
    attr.lineSpacing = lineSpacing;
    attr.range = ra;
    attr.cqTextAligment = textAligment;
    return attr;
}
@end

