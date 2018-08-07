//
//  CLAllJumpManager.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/17.
//  Copyright © 2016年 caiqr. All rights reserved.
// 统一注册URL  统一根据Url跳转 （包括 webView 和 controller）

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//注册匿名回调
typedef void (^AllJumpAnonymityCallback)(NSDictionary *params);

@interface CLAllJumpManager : NSObject

+ (CLAllJumpManager *)shareAllJumpManager;

/**
 注册跳转所需的navigation
 
 @param nav 跳转所需的navigation
 */
- (void)registerAllJumpNavigationController:(UINavigationController *)nav;

/**
 注册所有的映射关系
 */
- (void)registerAllMapController;


/**
 注册匿名回调

 @param url      回调url
 @param callBack 回调block
 */
- (void)registerCallBack:(NSString *)url block:(AllJumpAnonymityCallback)callBack;
/**
 根据url打开对应的controller

 @param url 对应的url
 */
- (void)open:(NSString *)url;


/**
 是否dismiss当前presentViewController

 @param url url
 @param dissmiss dismiss
 */
- (void)open:(NSString *)url dissmissPresent:(BOOL)dissmiss;
- (void)open:(NSString *)url dissmissPresent:(BOOL)dissmiss animation:(BOOL)animation;
/**
 根据url跳转 跳转结束后销毁当前页
 
 @param openUrl 跳转所需Url
 */
- (void)openDestoryWithURL:(NSString *)openUrl;
- (void)openDestoryWithURL:(NSString *)openUrl dismiss:(BOOL)dismiss;

@end
