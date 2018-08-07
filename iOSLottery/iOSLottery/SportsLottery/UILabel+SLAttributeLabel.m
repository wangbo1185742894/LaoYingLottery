//
//  UILabel+SLAttributeLabel.m
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/23.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "UILabel+SLAttributeLabel.h"

@implementation UILabel (SLAttributeLabel)
- (void)sl_attributeWithText:(NSString*)text controParams:(NSArray* )params
{
    @autoreleasepool {
        NSMutableAttributedString* attributedStr = [[NSMutableAttributedString alloc] initWithString:text];
        [params enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[SLAttributedTextParams class]]) {
                SLAttributedTextParams* attributeParam = (SLAttributedTextParams*)obj;
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

- (void)sl_attributeWithText:(NSString *)text beginTag:(NSString *)beginTag endTag:(NSString *)endTag color:(UIColor *)color
{

    if (!(text && text.length > 0)) return;
    NSArray *ranges = [self getRangeWithTag:beginTag string:text endFlagString:endTag];
    NSMutableArray *params = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSValue *value in ranges) {
        
        SLAttributedTextParams *param = [SLAttributedTextParams attributeRange:[value rangeValue] Color:color];
        [params addObject:param];
    }
    NSString *labelText = [text stringByReplacingOccurrencesOfString:beginTag withString:@""];
    labelText = [labelText stringByReplacingOccurrencesOfString:endTag withString:@""];
    
    [self sl_attributeWithText:labelText controParams:params];
}

- (NSArray *)getRangeWithTag:(NSString *)tag string:(NSString *)string endFlagString:(NSString *)endFlagString{
    
    NSMutableString *str = [string mutableCopy];
    NSMutableArray* ranges = [NSMutableArray arrayWithCapacity:0];
    NSRange range = NSMakeRange(0, 0);
    BOOL start = NO;
    
    for(int i=0; i<str.length; i++){
        NSString* s = [str substringWithRange:NSMakeRange(i, 1)];
        if ([s isEqualToString:tag]) {
            if (start) {
                [ranges addObject:[NSValue valueWithRange:range]];
            }
            start = YES;
            range.location = i;
            range.length = 0;
            [str deleteCharactersInRange:NSMakeRange(i, 1)];
            i--;
            continue;
        } else if ([endFlagString rangeOfString:s].location != NSNotFound){
            if (start) {
                [str deleteCharactersInRange:NSMakeRange(i, 1)];
                i--;
                [ranges addObject:[NSValue valueWithRange:range]];
                start = NO;
            }
        } else {
            if (start) {
                range.length++;
                if (i == (str.length - 1)) {
                    [ranges addObject:[NSValue valueWithRange:range]];
                }
            }
        }
    }
    return ranges;
}


@end

@implementation SLAttributedTextParams

+ (SLAttributedTextParams*)attributeRange:(NSRange)ra Color:(UIColor *)co Font:(UIFont*)fo
{
    SLAttributedTextParams* attr = [[SLAttributedTextParams alloc] init];
    attr.range = ra;
    attr.color = co;
    attr.font = fo;
    return attr;
    
}

+ (SLAttributedTextParams*)attributeRange:(NSRange)ra Color:(UIColor *)co
{
    SLAttributedTextParams* attr = [[SLAttributedTextParams alloc] init];
    attr.range = ra;
    attr.color = co;
    return attr;
}

+ (SLAttributedTextParams*)attributeRange:(NSRange)ra Font:(UIFont*)fo
{
    SLAttributedTextParams* attr = [[SLAttributedTextParams alloc] init];
    attr.range = ra;
    attr.font = fo;
    return attr;
    
}

+ (SLAttributedTextParams*)attributeStringWithAttachment:(NSTextAttachment *)attachment Range:(NSRange)ra Color:(UIColor *)co
{
    SLAttributedTextParams* attr = [[SLAttributedTextParams alloc] init];
    if (attachment.image == nil) {
        attr.attachment = nil;
    }else{
        attr.attachment = attachment;
    }
    attr.range = ra;
    attr.color = co;
    return attr;
}

+ (SLAttributedTextParams *)attributeRange:(NSRange)ra Color:(UIColor *)co Font:(UIFont *)fo link:(NSString *)link_name
{
    SLAttributedTextParams* attr = [[SLAttributedTextParams alloc] init];
    attr.range = ra;
    attr.color = co;
    attr.font = fo;
    attr.linkName = link_name;
    return attr;
}

+ (SLAttributedTextParams *)attributeRange:(NSRange)ra lineSpacing:(CGFloat)lineSpacing textAligment:(NSTextAlignment)textAligment{
    SLAttributedTextParams* attr = [[SLAttributedTextParams alloc] init];
    attr.lineSpacing = lineSpacing;
    attr.range = ra;
    attr.cqTextAligment = textAligment;
    return attr;
}

@end
