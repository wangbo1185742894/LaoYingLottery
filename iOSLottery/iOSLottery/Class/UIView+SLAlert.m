//
//  UIView+SLAlert.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/6/27.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "UIView+SLAlert.h"

#import <objc/runtime.h>
#import <objc/message.h>

#import "CQmyproxy.h"

@implementation UIView (SLAlert)


- (void)registerMonitorMethod
{

    [self resigtureSubClass];
}


#pragma mark - isa swizzling


- (void)resigtureSubClass{
    // isa-swizzling implement
    //构建类名
    NSString *className = [@"CQIsaSwizzling_" stringByAppendingString:NSStringFromClass(object_getClass(self))];
    //构建方法名
    NSString *methodName = @"removeFromSuperview";

    
    if (NSClassFromString(className)) {
        objc_disposeClassPair(NSClassFromString(className));
    }
    //构建子类
    Class subCls = objc_allocateClassPair(object_getClass(self), [className UTF8String], 0);
    //构建子类方法 实现方法重载
    class_addMethod(subCls, NSSelectorFromString(methodName), (IMP)removeFromSuperview, "v@");

    //应用中注册通过 objc_allocateClassPair 方法创建的类
    objc_registerClassPair(subCls);
    
    object_setClass(self, subCls);
    
}

//viewwillappear
static void removeFromSuperview(id self, SEL _cmd){
    
    //子类Class
    Class subCls = object_getClass(self);
    //父类Class
    Class supCls = class_getSuperclass(subCls);
    
    //在此通知service 需要检查并展示vc剩余的框了
    //    NSLog(@"我是 %@  我将要显示了", NSStringFromClass([supCls class]));
    
    NSLog(@"~~~~~~~~~~~~");
    [[CQmyproxy dealerProxy] alterClosed:NSStringFromClass(supCls)];
    
    
    //父类结构体？
    struct objc_super superInfo = {
        self,
        supCls
    };
    //方法最终调用 【super 。。。】
    ((void (*) (void * , SEL, ...))objc_msgSendSuper)(&superInfo, _cmd);
    
}


@end
