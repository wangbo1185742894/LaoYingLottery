//
//  CKPayIntermediaryInterface.h
//  iOSLottery
//
//  Created by 彩球 on 17/4/23.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CKPaymentVerifyCallBackInterface.h"
@protocol CKPayIntermediaryInterface <NSObject>

@property (nonatomic, strong, readonly) NSString* token;              //用户token
@property (nonatomic, strong, readonly) NSString *pay_version;         //支付payVersion
@property (nonatomic, readonly) BOOL authRealNameStatus;              //用户是否实名
@property (nonatomic, readonly) BOOL ownPayPwdStatus;                 //是否拥有支付密码
@property (nonatomic, readonly) BOOL freePaypwdStatus;                //免密状态
@property (nonatomic, assign, readonly) long long freePaypwdQuota;    //免密金额 (单位:分)
@property (nonatomic, assign, readonly) double accountBalance;
@property (nonatomic, strong, readonly) NSString* urlScheme;          //客户端自定义urlScheme
@property (nonatomic, strong, readonly) NSString* payHost;            //支付跳出跟踪标识

@property (nonatomic, strong, readonly) NSString* onlyRedPacketPayUrlPrefix;


@property (nonatomic, strong, readonly) NSString *payH5UrlVersion;    //H5支付成功页面版本号
@property (nonatomic, strong, readonly) NSString *payH5ClientType;    //H5支付页面业务区分ClientType
- (UIViewController<CKPaymentVerifyCallBackInterface>* )realNameViewController;
- (UIViewController<CKPaymentVerifyCallBackInterface>* )cardFrontViewController;


//取用户token  需外部配置
- (NSString *)getUserToken;

//toast 错误信息  需外部实现
- (void)showError:(NSString *)errorMes;
//加载动画
- (void)startLoading;
- (void)stopLoading;

//支付回调处理
- (void)backPayActionWithObj:(id)obj isException:(BOOL)isException OrderID:(NSString *)idString ContentController:(UIViewController *)contentController;

//
- (Class)ckInheritAPIClass;

- (void(^)(BOOL,long long))paymentBackAndSetFree;
/** 如果未设置支付密码，回调调用更新用户信息 */
- (void(^)(void))pamentNoSetPwdBack;

@end
