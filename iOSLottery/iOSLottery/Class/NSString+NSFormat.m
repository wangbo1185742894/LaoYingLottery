//
//  NSString+NSFormat.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/17.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "NSString+NSFormat.h"

@implementation NSString (NSFormat)

- (NSString*) stringByReplacingEachCharactersInRange:(NSRange)range withString:(NSString *)string {
    
    unichar a[range.length];
    for (NSInteger i = 0; i < range.length; i++) {
        a[i] = [string cStringUsingEncoding:NSASCIIStringEncoding][0];
    }
    return [self stringByReplacingCharactersInRange:range withString:[NSString stringWithCharacters:a length:range.length]];
}

@end
