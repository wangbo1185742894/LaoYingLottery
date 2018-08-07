//
//  CLShowHUDManager.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/15.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLShowHUDManager.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
@implementation CLShowHUDManager

+ (void)showHUDWithView:(UIView *)view text:(NSString *)text type:(CLShowHUDType)type delayTime:(CGFloat)delayTime{
    
    switch (type) {
        case CLShowHUDTypeOnlyText:
            [self showOnlyTextHUDWithView:view text:text delayTime:delayTime];
            break;
            
        default:
            break;
    } 
}
#pragma mark - 在window上展示
+ (void)showInWindowWithText:(NSString *)text type:(CLShowHUDType)type delayTime:(CGFloat)delayTime{
    
    [self showHUDWithView:((AppDelegate *)[[UIApplication sharedApplication] delegate]).window text:text type:type delayTime:delayTime];
}
#pragma mark - 在中间只展示文字
+ (void)showOnlyTextHUDWithView:(UIView *)view text:(NSString *)text delayTime:(CGFloat)delayTime{
    
    if ([text isKindOfClass:[NSString class]] && text.length > 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(text, @"HUD message title");
        hud.label.numberOfLines = 0;
        [hud hideAnimated:YES afterDelay:delayTime];
    }
}


@end
