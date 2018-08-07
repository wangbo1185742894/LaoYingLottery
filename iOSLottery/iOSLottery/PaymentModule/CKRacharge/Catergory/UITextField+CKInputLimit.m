//
//  UITextField+CQInputLimit.m
//  caiqr
//
//  Created by 任鹏杰 on 2017/4/28.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "UITextField+CKInputLimit.h"
#define kAlphaNum @"0123456789"

@implementation UITextField (CKInputLimit)

- (BOOL)limitNumberLength:(NSInteger)length ShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    
    BOOL canChange = [string isEqualToString:filtered];
    
    if (canChange) {
        NSString * toBeString = [self.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
        if (toBeString.length == 1 && [toBeString isEqualToString:@"0"]) {
            self.text = @"";
            return NO;
        }
        
        if ([toBeString length] > length) { //如果输入框内容大于5则弹出警告
            self.text = [toBeString substringToIndex:length];
            return NO;
        }
        
        return YES;
    } else {
        return NO;
    }
    
}

- (BOOL)limitNumberSum:(double)sum ShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL isHaveDian = YES;
    if ([self.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            //首字母不能为0和小数点
            if(self.text.length == 0){
                if(single == '.' || single == '0') {
                    self.text = @"0.";
                    //                    self.withdrawHoderLabel.hidden = YES;
                    return NO;
                }
            }
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                    
                }else{
                    [self.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (isHaveDian) {//存在小数点
                    //判断小数点的位数
                    NSRange ran = [self.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [self.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
    
}

- (BOOL)limitNumberWithMaxNumber:(long)maxBonus ShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    
    BOOL canChange = [string isEqualToString:filtered];
    
    if (canChange) {
        NSString * toBeString = [self.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
        if (toBeString.length == 1 && [toBeString isEqualToString:@"0"]) {
            self.text = @"";
            [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:nil userInfo:nil];
            return NO;
        }
        
        if ([toBeString longLongValue] > maxBonus) { //如果输入框内容大于5则弹出警告
            self.text = [NSString stringWithFormat:@"%ld", maxBonus];
            [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:nil userInfo:nil];
            return NO;
        }
        
        return YES;
    } else {
        return NO;
    }
    
}

@end
