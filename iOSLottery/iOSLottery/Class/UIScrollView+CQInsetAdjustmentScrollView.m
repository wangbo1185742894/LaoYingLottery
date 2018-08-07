//
//  UIScrollView+CQInsetAdjustmentScrollView.m
//  caiqr
//
//  Created by 小铭 on 2017/11/8.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "UIScrollView+CQInsetAdjustmentScrollView.h"
#import <objc/runtime.h>
#import "CQDefinition.h"

@implementation UIScrollView (CQInsetAdjustmentScrollView)

+ (void)load
{
    if (IOS_VERSION >= 11) {
        Class class = [self class];
        SEL originalSelector = NSSelectorFromString(@"setFrame:");
        SEL swizzledSelector = NSSelectorFromString(@"cqsetFrame:");
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

- (void)cqsetFrame:(CGRect)frame
{
    [self cqsetFrame:frame];
    self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
}


@end
