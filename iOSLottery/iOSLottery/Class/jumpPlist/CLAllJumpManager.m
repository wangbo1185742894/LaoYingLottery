//
//  CLAllJumpManager.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/17.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLAllJumpManager.h"
#import "CLRoutable.h"
#import "CLCheckProgessManager.h"
#import "CLWebViewActivityViewController.h"
#import "AppDelegate.h"
#import "CLMainTabbarViewController.h"
#import "CLBaseNavigationViewController.h"
#import "CLTools.h"
@interface CLAllJumpManager ()

@property (nonatomic, strong) NSMutableArray *presentViewControllerArray;//模态跳转的VC 对应的url class
@property (nonatomic, strong) NSMutableArray *pushViewControllerArray;//push的VC 对应的url class
@property (nonatomic, strong) NSArray *presentClass;//需要push的 类名
@property (nonatomic, strong) NSArray *pushClass;//需要模态的 类名
@end
@implementation CLAllJumpManager

+ (CLAllJumpManager *)shareAllJumpManager{
    
    static CLAllJumpManager *jumpManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        jumpManager = [[CLAllJumpManager alloc] init];
    });
    return jumpManager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
#pragma mark ------------ public Mothed ------------

#pragma mark - 注册所有的url 映射关系
- (void)registerAllMapController{
    //忽略Routble的异常崩溃
    [CLRoutable setIgnoresExceptions:YES];
    
    NSArray *configUrlArray = [self getClassConfigFromPlist];
    
    for (NSDictionary *urlDic in configUrlArray) {
        
        if ([urlDic[@"type"] isEqualToString:@"present"]) {
            
            [CLRoutable registerControllerWithURL:[self createRoutableUrl:urlDic[@"keys"] class:urlDic[@"class"] jumpType:@"present"] toPresentViewController:NSClassFromString(urlDic[@"class"])];
        }else if ([urlDic[@"type"] isEqualToString:@"push"]){
            [CLRoutable registerControllerWithURL:[self createRoutableUrl:urlDic[@"keys"] class:urlDic[@"class"] jumpType:@"push"] toPushViewController:NSClassFromString(urlDic[@"class"])];
        }
    }
}
#pragma mark - 注册匿名回调
- (void)registerCallBack:(NSString *)url block:(AllJumpAnonymityCallback)callBack{
    
    [CLRoutable registerAnonymityCallBack:url toCallback:callBack];
}
- (void)open:(NSString *)url{
    
    [self open:url dissmissPresent:NO];
}
- (void)open:(NSString *)url dissmissPresent:(BOOL)dissmiss{
    [self open:url dissmissPresent:dissmiss animation:YES];
}
#pragma mark - 打开 url 映射的 controller
- (void)open:(NSString *)url dissmissPresent:(BOOL)dissmiss animation:(BOOL)animation{
    
    if (!(url && url.length > 0)) {
        return;
    }
    //找到当前nav
    UINavigationController* sourceViewController =  nil;
    if (dissmiss) {
        
        UIViewController *vc = [CLTools getCurrentViewController];
        if (vc.presentingViewController) {
            
            if ([vc.presentingViewController isKindOfClass:[UINavigationController class]]) {
                sourceViewController = (UINavigationController *)vc.presentingViewController;
            }else if ([vc.presentingViewController isKindOfClass:[UITabBarController class]]){
                sourceViewController = ((UITabBarController *)vc.presentingViewController).selectedViewController;
            }else{
                sourceViewController = vc.presentingViewController.navigationController;
            }
        }else{
            if ([vc isKindOfClass:[UINavigationController class]]) {
                sourceViewController = (UINavigationController *)vc;
            }else{
                sourceViewController = vc.navigationController;
            }
        }
    }else{
        UIViewController *vc = [CLTools getCurrentViewController];
        if ([vc isKindOfClass:[UINavigationController class]]) {
            sourceViewController = (UINavigationController *)vc;
        }else{
            sourceViewController = vc.navigationController;
        }
    }
    [CLRoutable registerNavigationController:sourceViewController];
    
    //判断url 是http 跳转网页  还是跳转内部controller
    if ([url hasPrefix:@"http"] || [url hasPrefix:@"www"]) {
        //跳转webView
        CLWebViewActivityViewController *webViewController = [[CLWebViewActivityViewController alloc] init];
        webViewController.activityUrlString = url;
        CLBaseNavigationViewController *webNav = [[CLBaseNavigationViewController alloc] initWithRootViewController:webViewController];
        if (sourceViewController.presentedViewController) {
            [sourceViewController.presentedViewController presentViewController:webNav animated:YES completion:nil];
        }else{
            [sourceViewController.topViewController presentViewController:webNav animated:YES completion:nil];
        }
    }else if ([self checkIsTabbarRootViewControllerWithURL:url]){
        
        [self popRootViewControllerWithURL:url];
    }else {
        //内部跳转 或 匿名回调
        //校验是否需要登录支持
        if ([self judgeIsNeedLoginWithUrl:url]) {
            [[CLCheckProgessManager shareCheckProcessManager] checkIsLoginWithCallBack:^{
                [CLRoutable openWithURL:url dismiss:dissmiss animation:animation];
            }];
        }else{
            [CLRoutable openWithURL:url dismiss:dissmiss animation:animation];
        }
    }
}
#pragma mark - 检测是否是跳转主导航中的三个视图
- (BOOL)checkIsTabbarRootViewControllerWithURL:(NSString *)url{
    
    if ([url hasPrefix:@"CLHomeViewController"] ||
        [url hasPrefix:@"CLAwardAnnouncementViewController"] ||
        [url hasPrefix:@"CLUserCenterViewController"]||
        [url hasPrefix:@"MomentsViewController"]) {
        return YES;
    }
    return NO;
}
#pragma mark - pop到主导航的跟视图
- (void)popRootViewControllerWithURL:(NSString *)url{
    
    //找到当前nav
    CLMainTabbarViewController* rootTabbarVC = (CLMainTabbarViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;
    UINavigationController* sourceViewController = rootTabbarVC.selectedViewController;
    
    if (sourceViewController.presentedViewController) {
        
        [sourceViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    if ([url hasPrefix:@"CLHomeViewController"]){
        
        [sourceViewController popToRootViewControllerAnimated:NO];
//        [sourceViewController setNavigationBarHidden:YES];
        rootTabbarVC.selectedIndex = 0;
    }else if ([url hasPrefix:@"CLAwardAnnouncementViewController"]){
        
        [sourceViewController popToRootViewControllerAnimated:NO];
        rootTabbarVC.selectedIndex = 1;
    }else if ([url hasPrefix:@"MomentsViewController"]){
        
        [sourceViewController popToRootViewControllerAnimated:NO];
        rootTabbarVC.selectedIndex = 2;
    }
    else if ([url hasPrefix:@"CLUserCenterViewController"]){
        
        [sourceViewController popToRootViewControllerAnimated:NO];
        if (rootTabbarVC.viewControllers.count>3) {
            rootTabbarVC.selectedIndex = 3;
        }else{
            rootTabbarVC.selectedIndex = 2;
        }
        
    }
}

#pragma mark - push结束后销毁当前页
- (void)openDestoryWithURL:(NSString *)openUrl{
    
    [self openDestoryWithURL:openUrl dismiss:YES];
}
- (void)openDestoryWithURL:(NSString *)openUrl dismiss:(BOOL)dismiss{
    
    //找到当前nav
    UINavigationController* sourceViewController =  nil;
    if (dismiss) {
        
        UIViewController *vc = [CLTools getCurrentViewController];
        if (vc.presentingViewController) {
            
            if ([vc.presentingViewController isKindOfClass:[UINavigationController class]]) {
                sourceViewController = (UINavigationController *)vc.presentingViewController;
            }else if ([vc.presentingViewController isKindOfClass:[UITabBarController class]]){
                sourceViewController = ((UITabBarController *)vc.presentingViewController).selectedViewController;
            }else{
                sourceViewController = vc.presentingViewController.navigationController;
            }
        }else{
            if ([vc isKindOfClass:[UINavigationController class]]) {
                sourceViewController = (UINavigationController *)vc;
            }else{
                sourceViewController = vc.navigationController;
            }
        }
    }else{
        UIViewController *vc = [CLTools getCurrentViewController];
        if ([vc isKindOfClass:[UINavigationController class]]) {
            sourceViewController = (UINavigationController *)vc;
        }else{
            sourceViewController = vc.navigationController;
        }
    }
    [CLRoutable registerNavigationController:sourceViewController];
    
    //判断url 是http 跳转网页  还是跳转内部controller
    if ([openUrl hasPrefix:@"http"]) {
        //跳转webView
        CLWebViewActivityViewController *webViewController = [[CLWebViewActivityViewController alloc] init];
        webViewController.activityUrlString = openUrl;
        CLBaseNavigationViewController *webNav = [[CLBaseNavigationViewController alloc] initWithRootViewController:webViewController];
        [sourceViewController.topViewController presentViewController:webNav animated:YES completion:nil];
    }else{
        //内部跳转 或 匿名回调
        //校验是否需要登录支持
        if ([self judgeIsNeedLoginWithUrl:openUrl]) {
            [[CLCheckProgessManager shareCheckProcessManager] checkIsLoginWithCallBack:^{
                [CLRoutable openDestoryWithURL:openUrl];
            }];
        }else{
            [CLRoutable openDestoryWithURL:openUrl];
        }
    }
}
#pragma mark - 注册navigation
- (void)registerAllJumpNavigationController:(UINavigationController *)nav{
    
    [CLRoutable registerNavigationController:nav];
}


#pragma mark ------------ private Mothed ------------
#pragma mark - 添加对应的 类名 和 类名对应的url
- (NSArray *)getClassConfigFromPlist{
    
    NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"CLJumpPlistConfig" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:pathStr];
    return array;
}
#pragma mark - 根据key 和 class 生成url
- (NSString *)createRoutableUrl:(NSArray *)keys class:(NSString *)class jumpType:(NSString *)jumpType{
    
    if (keys.count > 0) {
        NSString *urlStr = @"";
        for (NSString *keyStr in keys) {
            urlStr = [NSString stringWithFormat:@"%@/:%@", urlStr, keyStr];
        }
        return [NSString stringWithFormat:@"%@_%@%@", class, jumpType, urlStr];
    }else{
        return [NSString stringWithFormat:@"%@_%@", class, jumpType];
    }
}
#pragma mark - 判断是否需要登录支持
- (BOOL)judgeIsNeedLoginWithUrl:(NSString *)url{
    
    //截取url前缀中的类名
    NSArray *urlArray = [url componentsSeparatedByString:@"/"];
    if (urlArray && urlArray.count > 0) {
        
        NSString *className = urlArray[0];
        NSArray *classNameArray = [className componentsSeparatedByString:@"_"];
        if (classNameArray && classNameArray.count > 0) {
            
            NSString *realName = classNameArray[0];
            return [self checkIsExistClass:realName];
        }
        
    }
    return NO;
}
- (BOOL)checkIsExistClass:(NSString *)className{
    
    NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"CLNeedLoginClassPlist" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:pathStr];
    
    return [array containsObject:className];
}
@end
