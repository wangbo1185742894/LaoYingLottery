//
//  UITextField+SLTextField.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/6/16.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "UITextField+SLTextField.h"

@implementation UITextField (SLTextField)

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{

    if (!(action == @selector(selectAll:))) return NO;
    
    [UIMenuController sharedMenuController].menuVisible = NO;
    
    return NO;
}

@end
