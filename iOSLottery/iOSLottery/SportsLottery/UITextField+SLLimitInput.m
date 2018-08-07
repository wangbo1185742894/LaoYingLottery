//
//  UITextField+SLLimitInput.m
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/22.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "UITextField+SLLimitInput.h"
#import "SLExternalService.h"
#define sl_kAlphaNum @"0123456789"
@implementation UITextField (SLLimitInput)

- (BOOL)sl_limitNumberMax:(long long)max ShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:sl_kAlphaNum] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    
    BOOL canChange = [string isEqualToString:filtered];
    
    if (canChange) {
        NSString * toBeString = [self.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
        if (toBeString.length == 1 && [toBeString isEqualToString:@"0"]) {
            self.text = @"";
            return NO;
        }
        
        if ([toBeString longLongValue] > max) { //如果输入框内容大于5则弹出警告
            self.text = [NSString stringWithFormat:@"%lld", max];
            [SLExternalService showError:[NSString stringWithFormat:@"最大倍数%lld", max]];
            return NO;
        }
        
        return YES;
    } else {
        return NO;
    }
    
}

@end
