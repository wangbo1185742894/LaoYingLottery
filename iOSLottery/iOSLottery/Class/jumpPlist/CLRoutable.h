//
//  CLRoutable.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/28.
//  Copyright © 2016年 caiqr. All rights reserved.
//

//对 第三方 Routable 进行封装 （方便以后替换第三方）

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//注册匿名回调
typedef void (^routableAnonymityCallback)(NSDictionary *params);

@interface CLRoutable : NSObject

/**
 注册跳转所需的navigation

 @param nav 跳转所需的navigation
 */
+ (void)registerNavigationController:(UINavigationController *)nav;

/**
 获取当前nav

 @return 返回当前nav
 */
+ (UINavigationController *)getCurrentNavigationController;

/**
 注册 push url
 
 @param url url
 @param ControllerClass 对应的url的controller的类
 */
+ (void)registerControllerWithURL:(NSString *)url toPushViewController:(Class)ControllerClass;

/**
 注册 present url
 
 @param url             对应的url
 @param ControllerClass 对应的controller的类
 */
+ (void)registerControllerWithURL:(NSString *)url toPresentViewController:(Class)ControllerClass;


/**
 注册 匿名 block 回调
 
 @param url      对应的url
 @param callback 回调block
 */
+ (void)registerAnonymityCallBack:(NSString *)url toCallback:(routableAnonymityCallback)callback;

/**
 根据url跳转
 
 @param openUrl 跳转所需Url
 */
+ (void)openWithURL:(NSString *)openUrl;
+ (void)openWithURL:(NSString *)openUrl dismiss:(BOOL)dismiss;
+ (void)openWithURL:(NSString *)openUrl dismiss:(BOOL)dismiss animation:(BOOL)animation;

/**
 根据url跳转 跳转结束后销毁当前页

 @param openUrl 跳转所需Url
 */
+ (void)openDestoryWithURL:(NSString *)openUrl;
/**
 是否忽略异常崩溃

 @param Ignore 是否忽略异常崩溃
 */
+ (void)setIgnoresExceptions:(BOOL)Ignore;

@end
