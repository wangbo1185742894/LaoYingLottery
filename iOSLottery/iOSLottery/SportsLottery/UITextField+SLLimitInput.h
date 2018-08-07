//
//  UITextField+SLLimitInput.h
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/22.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (SLLimitInput)

- (BOOL)sl_limitNumberMax:(long long)max ShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
