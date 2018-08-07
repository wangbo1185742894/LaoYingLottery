//
//  NSString+CLExpandString.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/22.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (CLExpandString)

/**
 *  计算文本宽高
 */

- (CGRect)boundingRectWithSize:(CGSize)size Font:(UIFont*)font;
- (CGRect)boundingRectFontOptionWithSize:(CGSize)size Font:(UIFont*)font;
- (CGRect)boundingRectFontOptionWithSize:(CGSize)size Font:(UIFont *)font Paragraph:(NSMutableParagraphStyle *)paragraph;
- (CGRect)boundingRectFontOptionWithSize:(CGSize)size Font:(UIFont *)font lineSpace:(CGFloat)textLineSpace;

@end
