//
//  NSString+NSFormat.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/17.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSFormat)

- (NSString*) stringByReplacingEachCharactersInRange:(NSRange)range withString:(NSString *)string;

@end
