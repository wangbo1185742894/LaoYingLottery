//
//  AppDelegate+Assist.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/3.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "AppDelegate+Assist.h"
#import <objc/runtime.h>
#import "CLNetworkReachabilityManager.h"
#import "CLMainTabbarViewController.h"
#import "QYSDK.h"
//启动接口
#import "CLAppContext.h"
#import "CLFirstStartModel.h"
#import "CLFirstStartRequest.h"
#import "CLPushActionManager.h"
#import "CLLaunchActivityManager.h"
//
#import "CLUmengShareManager.h"
@interface AppDelegate ()<CLRequestCallBackDelegate>
@property (nonatomic, strong) CLFirstStartRequest *firstStartRequest;
@end
@implementation AppDelegate (Assist)

+ (void)load
{
    swizzleMethod([AppDelegate class], @selector(application:didFinishLaunchingWithOptions:), @selector(assist_application:didFinishLaunchingWithOptions:));
    swizzleMethod([AppDelegate class], @selector(application:didReceiveRemoteNotification:), @selector(assist_application:didReceiveRemoteNotification:));
    
    
    Method registerUserNotiSel = class_getInstanceMethod([AppDelegate class], @selector(application:didRegisterUserNotificationSettings:));
    if (registerUserNotiSel) {
        swizzleMethod([AppDelegate class], @selector(application:didRegisterUserNotificationSettings:), @selector(assist_application:didRegisterUserNotificationSettings:));
    }
    
    swizzleMethod([AppDelegate class], @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:), @selector(assist_application:didRegisterForRemoteNotificationsWithDeviceToken:));
    swizzleMethod([AppDelegate class], @selector(application:didFailToRegisterForRemoteNotificationsWithError:), @selector(assist_application:didFailToRegisterForRemoteNotificationsWithError:));
    
    
    swizzleMethod([AppDelegate class], @selector(application:openURL:options:), @selector(assist_application:openURL:options:));
    
    
    Method openUrlMethod = class_getInstanceMethod([AppDelegate class], @selector(application:openURL:sourceApplication:annotation:));
    if (openUrlMethod) {
        swizzleMethod([AppDelegate class], @selector(application:openURL:sourceApplication:annotation:), @selector(assist_application:openURL:sourceApplication:annotation:));
    }
    
    Method continuActivitySel = class_getInstanceMethod([AppDelegate class], @selector(application:continueUserActivity:restorationHandler:));
    if (continuActivitySel) {
        swizzleMethod([AppDelegate class], @selector(application:continueUserActivity:restorationHandler:), @selector(assist_application:continueUserActivity:restorationHandler:));
    }
    
    //UIApplicationState
    swizzleMethod([AppDelegate class], @selector(applicationWillResignActive:), @selector(assist_applicationWillResignActive:));
    swizzleMethod([AppDelegate class], @selector(applicationDidEnterBackground:), @selector(assist_applicationDidEnterBackground:));
    swizzleMethod([AppDelegate class], @selector(applicationWillEnterForeground:), @selector(assist_applicationWillEnterForeground:));
    swizzleMethod([AppDelegate class], @selector(applicationDidBecomeActive:), @selector(assist_applicationDidBecomeActive:));
    swizzleMethod([AppDelegate class], @selector(applicationWillTerminate:), @selector(assist_applicationWillTerminate:));
    
}
#pragma mark - 注册七鱼
- (void)registerQY{
    
    [[QYSDK sharedSDK] registerAppId:@"1aa63717d2493753064627d9ec94bd2f" appName:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
}
#pragma mark ------------ delegate ------------
- (void)requestFinished:(CLBaseRequest *)request{
    
    if (request.urlResponse.success) {
        
        [CLAppContext context].firstStartInfo = [CLFirstStartModel mj_objectWithKeyValues:request.urlResponse.resp];
        //对活动图片做数据缓存
        [CLLaunchActivityManager saveLaunchActivityData];
    }
}
#pragma mark - private
- (BOOL)assist_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (UTests == 0) {
        
    }else{
        
    }
    //注册远程推送
    [self registerAPNTokenWith:application Options:launchOptions];
    
    [CLNetworkReachabilityManager startMonitoring];
    
    //集成第三方 (Umeng Wechat QQ Sina TingYun QY)
    
    //注册七鱼
    [self registerQY];
    
    //注册友盟统计
//    [CLUmengShareManager umengSetAppKeyWithOnLineKey:@"587742d4734be4689a000c6f" CVTKey:@"54ddb405fd98c5cc3e00026b"];
//    [CLUmengShareManager umengSetThirdPartyAppKeyWithWechaSessionKey:@"wxa0b4198c4ca30534"
//                                                         WechaSecret:@"bbbcd7028d68caa6bb1aa53b9af01127"
//                                                               QQKey:@"1104213057"
//                                                             SinaKey:@"1920389268"
//                                                          SinaSecret:@"02a8f57551265daa92b8f3f7cfdbfdad"];
    //[CLUmengShareManager registerAppKeyAndThirdPartyParameter];
    
    
    //启动接口
    self.firstStartRequest = [[CLFirstStartRequest alloc] init];
    self.firstStartRequest.delegate = self;
    [self.firstStartRequest start];
    return [self assist_application:application didFinishLaunchingWithOptions:launchOptions];
}


/** 接收远程推送消息 */
- (void)assist_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    [self assist_application:application didReceiveRemoteNotification:userInfo];
}

/** iOS8 注册远程推送 */
- (void)assist_application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
    
    [self assist_application:application didRegisterUserNotificationSettings:notificationSettings];
}

/** 获取推送token成功 */
- (void)assist_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    /** 七鱼获取推送token */
//    [[QYSDK sharedSDK] updateApnsToken:deviceToken];
    /** umeng获取推送token */
//    [UMessage registerDeviceToken:deviceToken];
    /** 客户端获取推送token */
    NSString *decToken = [NSString stringWithFormat:@"%@", deviceToken];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
    decToken = [decToken stringByTrimmingCharactersInSet:set];
    decToken = [decToken stringByReplacingOccurrencesOfString:@" " withString:@""];
//    [CQAppBaseConfig storeUserDefault:CQUserDefaultName_UserPushNotificationToken Content:decToken];
//    NSLog(@"----设备Token注册&本地化成功 token result is :%@",decToken);

    [CLAppContext context].deviceToken = decToken;
    [self assist_application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

/** 获取推送token失败 */
- (void)assist_application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
    
    [self assist_application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

/** ios8 and later Handoff callback */
- (BOOL)assist_application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
    /** talkingdata注册deepLink */
//    [TalkingDataAppCpa onReceiveDeepLink:userActivity.webpageURL];
    //Umeng
//    [UMSocialSnsService handleOpenURL:userActivity.webpageURL];
    
    return [self assist_application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
}

/** ios9 and later open url */
- (BOOL)assist_application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
//    talkingData
//    [TalkingDataAppCpa onReceiveDeepLink:url];
//    UMeng
//    [UMSocialSnsService handleOpenURL:url];
    //[CLUmengShareManager umengOpenUrliOS9OpenURL:url options:options];
    return [self assist_application:application openURL:url options:options];
}

/** ios8 and below open url */
- (BOOL)assist_application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    //[CLUmengShareManager umengOpenUrlOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    
    return [self assist_application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

/** 
 *  被挂起
 */
- (void)assist_applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

/** 
 *  进入后台
 */
- (void)assist_applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //清空推送角标
    [self clearApplicationBadge];
}

/** 
 *  从后台唤起 （客户端首次打开不调用）
 */
- (void)assist_applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

/** 
 *  被激活
 */
- (void)assist_applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

/** 
 *  退出
 */
- (void)assist_applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}





#pragma mark - 注册远程远程推送

- (void)registerAPNTokenWith:(UIApplication *)application Options:(NSDictionary *)launchOptions
{
    
    // 注册远程远程推送
//    [UMessage startWithAppkey:UMENG_APPKEY launchOptions:launchOptions];

    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {   //ios8及以上
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:nil];
        [application registerUserNotificationSettings:userSettings];
//        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
    }
    else
    {   //ios7
//        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert];
        
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                       UIRemoteNotificationTypeSound |
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
    
//    [UMessage setLogEnabled:NO];
//    [UMessage setAutoAlert:NO];
//    NSLog(@"----注册远程推送!");
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSLog(@"%@", userInfo);
    NSLog(@"%@", userInfo[@"push"]);
    
    [self pushUserInfo:userInfo];
}

#pragma mark - 处理推送消息
- (void)pushUserInfo:(NSDictionary *)userInfo{
    
    if (userInfo) {
        //判断是否是push进入app
        UIApplication *application = [UIApplication sharedApplication];
        if (userInfo[@"push"]) {
            if (application.applicationState != UIApplicationStateActive) {
                [[CLPushActionManager sharePushActionManager] pushUrlWithUrl:userInfo[@"push"]];
                [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            }
        }
    }
}
#pragma mark - 清空推送消息
- (void)clearApplicationBadge{
    //发送本地通知，设置badge = -1，这样可以清空角标但不清空通知栏，若使用 applicationIconBadgeNumber = 0 方式会直接清空通知栏
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification) {
        // 设置触发通知的时间
        NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
        notification.fireDate = fireDate;
        // 时区
        notification.timeZone = [NSTimeZone defaultTimeZone];
        // 设置重复的间隔
        notification.repeatInterval = 0;
        // 通知内容
        notification.alertBody = nil;
        notification.applicationIconBadgeNumber = -1;
        // 通知被触发时播放的声音
        notification.soundName = nil;
        // 执行通知注册
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}
#pragma mark - 方法交换  swizzle method

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector)  {    // the method might not exist in the class, but in its superclass
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);    // class_addMethod will fail if original method already exists
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));    // the method doesn’t exist and we just added one
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma mark ------------ 添加属性 ------------
static char firstStartRequestKey;
- (void)setFirstStartRequest:(CLFirstStartRequest *)firstStartRequest{
    
    objc_setAssociatedObject(self, &firstStartRequestKey, firstStartRequest, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CLFirstStartRequest *)firstStartRequest{
    
    return objc_getAssociatedObject(self, &firstStartRequestKey);
}
@end
