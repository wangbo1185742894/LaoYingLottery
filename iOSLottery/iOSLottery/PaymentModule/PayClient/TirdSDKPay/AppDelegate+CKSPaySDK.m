//
//  AppDelegate+CKSPaySDK.m
//  caiqr
//
//  Created by 洪利 on 2017/4/28.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "AppDelegate+CKSPaySDK.h"
#import <objc/runtime.h>
#import "SPayClient.h"
#import "CKPayClient.h"
@implementation AppDelegate (CKSPaySDK)

+(void)load{

    [self SPaySDK_methodSwizzlingWithOriginalSelector:@selector(application:didFinishLaunchingWithOptions:) bySwizzledSelector:@selector(SPaySDK_application:didFinishLaunchingWithOptions:)];
//    [self SPaySDK_methodSwizzlingWithOriginalSelector:@selector(applicationWillEnterForeground:) bySwizzledSelector:@selector(SPaySDK_applicationWillEnterForeground:)];
    


}



- (BOOL)SPaySDK_application:(UIApplication *)applocation didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    return [self SPaySDK_application:applocation didFinishLaunchingWithOptions:launchOptions];
}



- (void)SPaySDK_applicationWillEnterForeground:(UIApplication *)application{
    [[CKPayClient sharedManager] openUrl:nil];
    [[SPayClient sharedInstance] applicationWillEnterForeground:application];
}


//方法交换
+ (void)SPaySDK_methodSwizzlingWithOriginalSelector:(SEL)originalSelector bySwizzledSelector:(SEL)swizzledSelector{
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



@end
