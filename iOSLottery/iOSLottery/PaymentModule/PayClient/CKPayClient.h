//
//  CKPayClient.h
//  iOSLottery
//
//  Created by 彩球 on 17/4/18.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CKPayIntermediaryInterface.h"
#import "CKPayChannelFilterInterface.h"

@class CKPaymentBaseSource;

typedef NS_OPTIONS(NSUInteger, CKPayChannelVerifyType) {
    
    CKPayChannelVerifyTypeNone = 0,
    CKPayChannelVerifyTypePayPwd = 1 << 0,
    CKPayChannelVerifyTypeRealName = 1 << 1,
    CKPayChannelVerifyTypeCardFront = 1 << 2,
    CKPayChannelVerifyTypeVIPService = 1 << 5,
};


@protocol CKPayClientDelegate <NSObject>

@optional
- (void)ck_PayClinetStartPayment;
- (void)ck_payClientEndPaymentWithReqState:(BOOL)state message:(id)msg;
- (void)ck_didPayment;
@end


@interface CKPayClient : NSObject

@property (nonatomic, strong) id<CKPayIntermediaryInterface> intermediary;
@property (nonatomic, weak) id<CKPayClientDelegate> delegate;
@property (nonatomic, strong) CKPaymentBaseSource *source;
@property (nonatomic, strong) id<CKPaychannelDataInterface> channel;
/** 标志是不是SDK支付 */
@property (nonatomic, readwrite) BOOL isSDKPayment;

@property (nonatomic, strong) UIViewController* launchViewController;

+ (void) setPayIntermediary:(Class)class;

+ (CKPayClient *)sharedManager;

+ (void) startPay;


+ (CKPayChannelVerifyType)checkPayTypeOfChannel:(id<CKPaychannelDataInterface>)channel;

//call back
@property (nonatomic, copy) void(^payFinish)(id payStateModel,id paySuccessModel);
//标记支付方式是否需要处理异常
@property (nonatomic, assign) BOOL isNeedHandleException;
//标记支付开始
@property (nonatomic, assign) BOOL didStartPayMent;
//标记是否需要根据URl执行下一步还是走默认的下一步
@property (nonatomic, assign) BOOL isExceptionCallback;

+ (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options;
+ (void)applicationWillEnterForeground:(UIApplication *)app;
+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;


- (BOOL) openUrl:(NSURL*)url;






/* 入参
 
    1、用户信息
    2、支付Source
    3、LaunchVC
    4、实名认证类名
    5、卡前置类名
 
    
 
    支付成功回调url
    支付完成回调block
 
 */
@end
