//
//  UILabel+CLAttributeLabel.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/15.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "UILabel+CLAttributeLabel.h"

@implementation UILabel (CLAttributeLabel)
- (void)attributeWithText:(NSString*)text controParams:(NSArray* )params
{
    /*
     [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,5)];
     [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,12)];
     [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
     [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:30.0] range:NSMakeRange(0, 5)];
     [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:30.0] range:NSMakeRange(6, 12)];
     [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:30.0] range:NSMakeRange(19, 6)];
     */
    @autoreleasepool {
        NSMutableAttributedString* attributedStr = [[NSMutableAttributedString alloc] initWithString:text];
        [params enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[AttributedTextParams class]]) {
                AttributedTextParams* attributeParam = (AttributedTextParams*)obj;
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

- (void)attributeWithText:(NSString *)text beginTag:(NSString *)beginTag endTag:(NSString *)endTag color:(UIColor *)color{
    if (!(text && text.length > 0)) return;
    NSArray *ranges = [self getRangeWithTag:beginTag string:text endFlagString:endTag];
    NSMutableArray *params = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSValue *value in ranges) {
        
        AttributedTextParams *param = [AttributedTextParams attributeRange:[value rangeValue] Color:color];
        [params addObject:param];
    }
    NSString *labelText = [text stringByReplacingOccurrencesOfString:beginTag withString:@""];
    labelText = [labelText stringByReplacingOccurrencesOfString:endTag withString:@""];
    
    [self attributeWithText:labelText controParams:params];
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

@implementation AttributedTextParams

+ (AttributedTextParams*)attributeRange:(NSRange)ra Color:(UIColor *)co Font:(UIFont*)fo
{
    AttributedTextParams* attr = [[AttributedTextParams alloc] init];
    attr.range = ra;
    attr.color = co;
    attr.font = fo;
    return attr;
    
}

+ (AttributedTextParams*)attributeRange:(NSRange)ra Color:(UIColor *)co
{
    AttributedTextParams* attr = [[AttributedTextParams alloc] init];
    attr.range = ra;
    attr.color = co;
    return attr;
}

+ (AttributedTextParams*)attributeRange:(NSRange)ra Font:(UIFont*)fo
{
    AttributedTextParams* attr = [[AttributedTextParams alloc] init];
    attr.range = ra;
    attr.font = fo;
    return attr;
    
}

+ (AttributedTextParams*)attributeStringWithAttachment:(NSTextAttachment *)attachment Range:(NSRange)ra Color:(UIColor *)co
{
    AttributedTextParams* attr = [[AttributedTextParams alloc] init];
    if (attachment.image == nil) {
        attr.attachment = nil;
    }else{
        attr.attachment = attachment;
    }
    attr.range = ra;
    attr.color = co;
    return attr;
}

+ (AttributedTextParams *)attributeRange:(NSRange)ra Color:(UIColor *)co Font:(UIFont *)fo link:(NSString *)link_name
{
    AttributedTextParams* attr = [[AttributedTextParams alloc] init];
    attr.range = ra;
    attr.color = co;
    attr.font = fo;
    attr.linkName = link_name;
    return attr;
}

+ (AttributedTextParams *)attributeRange:(NSRange)ra lineSpacing:(CGFloat)lineSpacing textAligment:(NSTextAlignment)textAligment{
    AttributedTextParams* attr = [[AttributedTextParams alloc] init];
    attr.lineSpacing = lineSpacing;
    attr.range = ra;
    attr.cqTextAligment = textAligment;
    return attr;
}

@end
