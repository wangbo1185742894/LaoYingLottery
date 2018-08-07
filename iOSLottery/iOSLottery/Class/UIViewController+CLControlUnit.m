//
//  UIViewController+CLControlUnit.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/17.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "UIViewController+CLControlUnit.h"
#import "CLShowHUDManager.h"
#import "CLLoadingAnimationView.h"
@implementation UIViewController (CLControlUnit)

- (void) show:(NSString*)title {
    [self show:title delay:1.f];
}

- (void) show:(NSString*)title delay:(NSTimeInterval)delay {
    
    [CLShowHUDManager showHUDWithView:self.view text:title type:CLShowHUDTypeOnlyText delayTime:delay];
}

- (void)showLoading{
    
    [[CLLoadingAnimationView shareLoadingAnimationView] showLoadingAnimationWithView:self.view type:CLLoadingAnimationTypeNormal];
}

- (void)stopLoading{
    
    [[CLLoadingAnimationView shareLoadingAnimationView] stop];
}
@end
