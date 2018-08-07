//
//  CQCommonAlterControl.h
//  caiqr
//
//  Created by 洪利 on 2017/3/29.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol CQAlterControlDelegate <NSObject>
@optional
//弹窗 被关闭
- (void)alterClosed:(id)alterInfo;

//控制器viewWillAppear
- (void)viewControllerWillExecuteWillAppear:(id)viewController;
////控制器viewWillDisappear
//- (void)viewControllerWillExecuteWillDisappear:(id)viewController;

//注册弹框,VC发起
- (void)addAlterWithArray:(NSArray *)array withController:(NSString *)controllerName;

//注册全局弹窗
- (void)addGlobalAlertWithArray:(NSArray *)array;
//开始执行
- (void)startShowAlters:(NSString *)controllerName;


@end



@protocol CQAlterLoadViewDelegate <NSObject>

//自助实现加载的弹窗需要向control注册代理 并且实现此方法，在此方法中添加加载的实现
- (void)alertCanShowAtTheMoment;

@end


////如果选择自己实现添加逻辑，那么需要实现此方法
//typedef void(^CanShowAlertView)(NSString *alterClass);

@interface CQCommonAlterControl : NSObject


@property (nonatomic ,assign) id<CQAlterLoadViewDelegate>alertViewShowDelegate;
//@property (nonatomic, copy) CanShowAlertView canShowAlter;

+ (instancetype)sharedCommonControl;



//自主实现加载的弹窗用此方法注册代理对象
- (void)addAlertDelegater:(id)delegater;

@end
