//
//  CKRechargeViewController.h
//  caiqr
//
//  Created by 任鹏杰 on 2017/4/28.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CKRechargeConfig,CKPaymentBaseSource;
@interface CKRechargeHomeView : UIView

+ (instancetype)rechargeViewController:(UIViewController __weak *)pushController paymentActionBlock:(void(^)(CKPaymentBaseSource *,NSString *))paymentActionBlock;

@property (nonatomic, weak) UIViewController *pushController;

@property (nonatomic, readwrite) BOOL buttonStatus;

@property (nonatomic, assign) NSInteger defaultAmount;
/**
 需要配置Source回调等请求开始
 */
@property (nonatomic, copy) void(^paymentActionBlock)(CKPaymentBaseSource *,NSString *);

/** 开始请求 le  */
- (void)startRequest;

/** 开始支付 */

- (void)startPayment;
@end
