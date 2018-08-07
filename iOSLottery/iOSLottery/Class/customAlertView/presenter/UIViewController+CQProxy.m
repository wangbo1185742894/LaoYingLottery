//
//  CQBasicViewController+CQProxy.m
//  caiqr
//
//  Created by 洪利 on 2017/3/28.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "UIViewController+CQProxy.h"
#import "CQCommonAlterControl.h"

#import "CQCommonAlterPresenter.h"
#import <objc/message.h>

#import "UIView+SLAlert.h"

static const NSString *lclassnamekey = @"lclassname";

@implementation UIViewController (CQProxy)

+ (void)cq_methodSwizzlingWithOriginalSelector:(SEL)originalSelector bySwizzledSelector:(SEL)swizzledSelector{
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



- (void)addAlterToservice:(id)alertView withSuperView:(id)superView option:(CQAlertViewDisPlayedOption)option{
    //数据有效，添加观察者，监测VC生命周期
    if (alertView && superView) {
        CQCommonAlterConfigModel *model = [CQCommonAlterPresenter addAlertView:alertView withSuperView:superView option:option];
        if (!self.lClassName) {
            [[CQmyproxy dealerProxy] addAlterWithArray:@[model] withController:NSStringFromClass([self class])];
            self.lClassName = NSStringFromClass([self class]);
            [self resigtureSubClass];
        }else{
             [[CQmyproxy dealerProxy] addAlterWithArray:@[model] withController:NSStringFromClass([self.superclass class])];
        }
        
        [model.alertView registerMonitorMethod];
        
    }
 
}

- (void)addAlertToserviceAndLoadBySelf:(NSString *)alertClassName option:(CQAlertViewDisPlayedOption)option{
    //数据有效，添加观察者，监测VC生命周期
    if (alertClassName) {
        CQCommonAlterConfigModel *model = [CQCommonAlterPresenter addAlertViewWithClassName:alertClassName option:option];
        if (!self.lClassName) {
            [[CQmyproxy dealerProxy] addAlterWithArray:@[model] withController:NSStringFromClass([self class])];
            self.lClassName = NSStringFromClass([self class]);
            [self resigtureSubClass];
        }else{
            [[CQmyproxy dealerProxy] addAlterWithArray:@[model] withController:NSStringFromClass([self.superclass class])];

        }
        
    }
}



#pragma mark - isa swizzling


- (void)resigtureSubClass{
    // isa-swizzling implement
    //构建类名
    NSString *newName = [@"CQIsaSwizzling_" stringByAppendingString:NSStringFromClass(object_getClass(self))];
    //构建方法名
    NSString *methodName = @"viewWillAppear:";
//    NSString *methodName2 = @"viewWillDisappear:";
    if (NSClassFromString(newName)) {
        objc_disposeClassPair(NSClassFromString(newName));
    }
    //构建子类
    Class subCls = objc_allocateClassPair(object_getClass(self), [newName UTF8String], 0);
    //构建子类方法 实现方法重载
    class_addMethod(subCls, NSSelectorFromString(methodName), (IMP)viewWillAppear, "v@:@");
//    class_addMethod(subCls, NSSelectorFromString(methodName2), (IMP)viewWillDisappear, "v@:@");
    objc_registerClassPair(subCls);
    object_setClass(self, subCls);

}

//viewwillappear
static void viewWillAppear(id self, SEL _cmd, bool animate){
    
    //子类Class
    Class subCls = object_getClass(self);
    //父类Class
    Class supCls = class_getSuperclass(subCls);
    
    //在此通知service 需要检查并展示vc剩余的框了
//    NSLog(@"我是 %@  我将要显示了", NSStringFromClass([supCls class]));
    [[CQmyproxy dealerProxy] viewControllerWillExecuteWillAppear:NSStringFromClass([supCls class])];
    //父类结构体？
    struct objc_super superInfo = {
        self,
        supCls
    };
    //方法最终调用 【super 。。。】
    ((void (*) (void * , SEL, ...))objc_msgSendSuper)(&superInfo, _cmd, animate);
    
}
////viewwillappear
//static void viewWillDisappear(id self, SEL _cmd, bool animate){
//    
//    //子类Class
//    Class subCls = object_getClass(self);
//    //父类Class
//    Class supCls = class_getSuperclass(subCls);
//    
//    //在此通知service 需要检查并展示vc剩余的框了
//    //    NSLog(@"我是 %@  我将要显示了", NSStringFromClass([supCls class]));
//    [[CQmyproxy dealerProxy] viewControllerWillExecuteWillAppear:NSStringFromClass([supCls class])];
//    //父类结构体？
//    struct objc_super superInfo = {
//        self,
//        supCls
//    };
//    //方法最终调用 【super 。。。】
//    ((void (*) (void * , SEL, ...))objc_msgSendSuper)(&superInfo, _cmd, animate);
//    
//}

- (void)setLClassName:(NSString *)lClassName{
    objc_setAssociatedObject(self, &lclassnamekey, lClassName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)lClassName{
    return objc_getAssociatedObject(self, &lclassnamekey);
}


@end
