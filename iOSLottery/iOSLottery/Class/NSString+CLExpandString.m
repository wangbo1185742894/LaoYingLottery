//
//  NSString+CLExpandString.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/22.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "NSString+CLExpandString.h"

@implementation NSString (CLExpandString)

- (CGRect)boundingRectWithSize:(CGSize)size Font:(UIFont*)font{
    
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName:font}
                              context:nil];
}

- (CGRect)boundingRectFontOptionWithSize:(CGSize)size Font:(UIFont *)font
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    
    paragraph.lineBreakMode = NSLineBreakByCharWrapping;
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName: paragraph}
                              context:nil];
}

- (CGRect)boundingRectFontOptionWithSize:(CGSize)size Font:(UIFont *)font Paragraph:(NSMutableParagraphStyle *)paragraph
{
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName: paragraph}
                              context:nil];
}

- (CGRect)boundingRectFontOptionWithSize:(CGSize)size Font:(UIFont *)font lineSpace:(CGFloat)textLineSpace
{
    NSMutableParagraphStyle *contentTextStyle = [[NSMutableParagraphStyle alloc] init];
    contentTextStyle.lineSpacing = textLineSpace;
    return [self boundingRectFontOptionWithSize:size Font:font Paragraph:contentTextStyle];
}

@end
