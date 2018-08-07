//
//  AppDelegate.m
//  iOSLottery
//
//  Created by 彩球 on 16/10/31.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "AppDelegate.h"
#import "CLMainTabbarViewController.h"
#import "CLAllJumpManager.h"
#import "CLPushActionManager.h"
#import "CKPayClient.h"
#import "CKPayConfig.h"
#import "CLSportsLotteryService.h"
#import "SLExternalService.h"
#import "CLAlertPromptMessageView.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //配置window.rootViewController
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[CLMainTabbarViewController alloc] init];
    [self.window makeKeyAndVisible];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //注册所有统跳 映射
    [[CLAllJumpManager shareAllJumpManager] registerAllMapController];
    [CKPayClient sharedManager].intermediary = [[CKPayConfig alloc] init];
    [SLExternalService sl_ShareExternalService].externalService = [[CLSportsLotteryService alloc] init];
    //判断是否是push进入app
    //push进入 获取推送消息
    [CLPushActionManager sharePushActionManager].isStart = YES;
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]) {
        if (application.applicationState != UIApplicationStateActive) {
            [[CLPushActionManager sharePushActionManager] pushUrlWithUrl:[[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] objectForKey:@"push"]];
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }
    }
    
    return YES;
}

// get remote nofitication info
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
}

// register token success
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken{
    
}
// register token fail
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
}

#ifdef __IPHONE_8_0
// register notification iOS8
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler {
    
}

/*ios8 and later Handoff callback  Instruction -> http://www.cocoachina.com/ios/20150409/11515.html*/
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray * __nullable restorableObjects))restorationHandler{
    
    return YES;
}

#endif

#ifdef __IPHONE_9_0

//ios9 openUrl
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    
    [[CLPushActionManager sharePushActionManager] pushUrlWithUrl:url.absoluteString];
    return YES;
}

#endif

//ios8 and below openUrl
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    [[CLPushActionManager sharePushActionManager] pushUrlWithUrl:url.absoluteString];
    return YES;
}


#if ((__IPHONE_OS_VERSION_MAX_ALLOWED >= 80000) && (__IPHONE_OS_VERSION_MAX_ALLOWED < 90000))
//ios8 and below hidden Third Keyboard
- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier {
    if ([extensionPointIdentifier isEqualToString:@"com.apple.keyboard-service"]) {
        return NO;
    }
    return YES;
}

#endif


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
