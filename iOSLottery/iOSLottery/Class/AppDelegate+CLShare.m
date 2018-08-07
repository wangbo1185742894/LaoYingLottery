//
//  AppDelegate+CLShare.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/4/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "AppDelegate+CLShare.h"

#import <objc/runtime.h>

#import "CLUmengShareManager.h"

@implementation AppDelegate (CLShare)

+ (void)load
{
    if (UTests == 0) {
        
        [self cl_methodSwizzlingWithOriginalSelector:@selector(application:openURL:sourceApplication:annotation:) bySwizzledSelector:@selector(clShare_application:openURL:sourceApplication:annotation:)];
        
        [self cl_methodSwizzlingWithOriginalSelector:@selector(application:openURL:options:) bySwizzledSelector:@selector(clShare_application:openURL:options:)];
        
        
        [self cl_methodSwizzlingWithOriginalSelector:@selector(application:didFinishLaunchingWithOptions:) bySwizzledSelector:@selector(clShare_application:didFinishLaunchingWithOptions:)];
    }

}

//方法交换
+ (void)cl_methodSwizzlingWithOriginalSelector:(SEL)originalSelector bySwizzledSelector:(SEL)swizzledSelector{
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

- (BOOL)clShare_application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
     [CLUmengShareManager umengOpenUrlOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    
    return [self clShare_application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (BOOL)clShare_application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    [CLUmengShareManager umengOpenUrliOS9OpenURL:url options:options];
    
    return [self clShare_application:app openURL:url options:options];

}

- (BOOL)clShare_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
    [CLUmengShareManager registerAppKeyAndThirdPartyParameter];
    
    return [self clShare_application:application didFinishLaunchingWithOptions:launchOptions];

}

@end
