//
//  CLRoutable.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/28.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLRoutable.h"
#import "Routable.h"

@implementation CLRoutable

+ (void)registerNavigationController:(UINavigationController *)nav{
    
    [Routable sharedRouter].navigationController = nav;
}
+ (UINavigationController *)getCurrentNavigationController{
    
    return [Routable sharedRouter].navigationController;
}
+ (void)registerControllerWithURL:(NSString *)url toPushViewController:(Class)ControllerClass{
    
    [[Routable sharedRouter] map:url toController:ControllerClass];
}

+ (void)registerControllerWithURL:(NSString *)url toPresentViewController:(Class)ControllerClass{
    
    [[Routable sharedRouter] map:url toController:ControllerClass withOptions:[[UPRouterOptions modal] withPresentationStyle:UIModalPresentationFormSheet]];
}

+ (void)registerAnonymityCallBack:(NSString *)url toCallback:(routableAnonymityCallback)callback{
    
    [[Routable sharedRouter] map:url toCallback:callback];
}

+ (void)openWithURL:(NSString *)openUrl{
    
    [[Routable sharedRouter] open:openUrl];
}
+ (void)openWithURL:(NSString *)openUrl dismiss:(BOOL)dismiss{
    
    [[Routable sharedRouter] open:openUrl dismiss:dismiss];
}
+ (void)openWithURL:(NSString *)openUrl dismiss:(BOOL)dismiss animation:(BOOL)animation{
    
    [[Routable sharedRouter] open:openUrl dismiss:dismiss animation:animation];
}
+ (void)openDestoryWithURL:(NSString *)openUrl{
    
    [[Routable sharedRouter] openWithDestory:openUrl];
}

+ (void)setIgnoresExceptions:(BOOL)Ignore{
    
    [[Routable sharedRouter] setIgnoresExceptions:Ignore];
}
@end
