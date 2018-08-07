//
//  CLShowHUDManager.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/15.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger , CLShowHUDType) {
    
    CLShowHUDTypeOnlyText = 0
};

@interface CLShowHUDManager : NSObject

+ (void)showHUDWithView:(UIView *)view text:(NSString *)text type:(CLShowHUDType)type delayTime:(CGFloat)delayTime;

+ (void)showInWindowWithText:(NSString *)text type:(CLShowHUDType)type delayTime:(CGFloat)delayTime;
@end
