//
//  UINavigationController+SLBaseNavigationController.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "UINavigationController+SLBaseNavigationController.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static char *titleLabelKey = "label";

@implementation UINavigationController (SLBaseNavigationController)

//+(void)load{
//
//    [self sl_methodSwizzlingWithOriginalSelector:@selector(viewDidLoad) bySwizzledSelector:@selector(sl_viewDidLoad)];
//}
//
//- (void)sl_viewDidLoad
//{
//    if (!self.titleLabel) {
//        self.titleLabel = [[UILabel alloc] init];
//        self.titleLabel.text = @"asfasdfasdfasdf";
//        //[self.titleLabel sizeToFit];
//    }
//    NSLog(@"%@", self.titleLabel);
//    self.navigationItem.titleView = self.titleLabel;
//    NSLog(@"%@", self.navigationItem.titleView);
//    return [self sl_viewDidLoad];
//
//}

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
