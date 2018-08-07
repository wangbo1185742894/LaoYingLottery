//
//  UITextField+InputLimit.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/10.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (InputLimit)

- (BOOL)limitNumberLength:(NSInteger)length ShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;


- (BOOL)limitNumberSum:(double)sum ShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;


/**
 限制最大值

 @param maxBonus 最大值
 @param range    改变位置
 @param string   改变的值

 @return 是否改变textfield值
 */
- (BOOL)limitNumberWithMaxNumber:(long)maxBonus ShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
@end
