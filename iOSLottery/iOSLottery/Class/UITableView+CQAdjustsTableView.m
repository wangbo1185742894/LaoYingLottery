//
//  UITableView+CQAdjustsTableView.m
//  caiqr
//
//  Created by 小铭 on 2017/11/6.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "UITableView+CQAdjustsTableView.h"
#import <objc/runtime.h>
#import "CQDefinition.h"
@implementation UITableView (CQAdjustsTableView)

+ (void)load
{
    if (IOS_VERSION >= 11) {
        Class class = [self class];
        SEL originalSelector = NSSelectorFromString(@"setDelegate:");
        SEL swizzledSelector = NSSelectorFromString(@"cqsetDelegate:");
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

- (void)cqsetDelegate:(id)delegate
{
    [self cqsetDelegate:delegate];
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
}

@end
