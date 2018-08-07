//
//  UITextField+CQInputLimit.h
//  caiqr
//
//  Created by 任鹏杰 on 2017/4/28.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (CKInputLimit)

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
