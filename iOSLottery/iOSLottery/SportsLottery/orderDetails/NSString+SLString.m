//
//  NSString+SLString.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/22.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "NSString+SLString.h"

@implementation NSString (SLString)

- (CGRect)boundingRectFontOptionWithSize:(CGSize)size Font:(UIFont *)font
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    
    paragraph.lineBreakMode = NSLineBreakByCharWrapping;
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName: paragraph}
                              context:nil];
}


@end
