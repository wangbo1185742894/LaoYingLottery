//
//  UIViewController+SLBaseViewController.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "UIViewController+SLBaseViewController.h"
#import "SLConfigMessage.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@implementation UIViewController (SLBaseViewController)

static char *titleLabelKey = "label";

+(void)load{
    
    [self sl_methodSwizzlingWithOriginalSelector:@selector(viewDidLoad) bySwizzledSelector:@selector(sl_viewDidLoad)];
}

- (void)sl_viewDidLoad
{
    
    return [self sl_viewDidLoad];
    
}

- (void)setNavTitle:(NSString *)title{
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = SL_FONT_BOLD(18);
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    titleLabel.text = title;
    [titleLabel sizeToFit];
}

+ (void)sl_methodSwizzlingWithOriginalSelector:(SEL)originalSelector bySwizzledSelector:(SEL)swizzledSelector{
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod = class_addMethod(class,originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)setTitleLabel:(UILabel *)titleLabel
{
    
    objc_setAssociatedObject(self, &titleLabelKey, titleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)titleLabel
{
    
    return objc_getAssociatedObject(self, &titleLabelKey);
    
}

@end
