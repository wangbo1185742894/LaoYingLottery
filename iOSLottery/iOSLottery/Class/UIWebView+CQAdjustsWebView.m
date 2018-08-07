//
//  UIWebView+CQAdjustsWebView.m
//  caiqr
//
//  Created by 洪利 on 2017/11/8.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "UIWebView+CQAdjustsWebView.h"
#import <objc/runtime.h>
#import "CQDefinition.h"

@implementation UIWebView (CQAdjustsWebView)

+ (void)load
{
    if (IOS_VERSION >= 11) {
        Class class = [self class];
        SEL originalSelector = NSSelectorFromString(@"setDelegate:");
        SEL swizzledSelector = NSSelectorFromString(@"cq_wb_setDelegate:");
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
}

- (void)cq_wb_setDelegate:(id)delegate
{
    [self cq_wb_setDelegate:delegate];
    self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
}

@end
