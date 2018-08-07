//
//  CKQuickPayHomeView.h
//  CKPayClient
//
//  Created by 小铭 on 2017/5/5.
//  Copyright © 2017年 caiqr. All rights reserved.
//  快速支付主页

#import <UIKit/UIKit.h>
@class CKPaymentBaseSource;
@interface CKQuickPayHomeView : UIView

+ (instancetype)QuickPaymentViewPreHandleToken:(NSString *)prehandleToken viewController:(UIViewController __weak *)pushController paymentActionBlock:(void(^)(CKPaymentBaseSource *,NSString *))paymentActionBlock;

@property (nonatomic, weak) UIViewController *pushController;

/**
 需要配置Source回调等Block 和 开始请求操作
 */
@property (nonatomic, copy) void(^paymentActionBlock)(CKPaymentBaseSource *,NSString *);
/** 取消支付block */
@property (nonatomic, copy) void(^cancelButtonBlock)();

@property (nonatomic, strong) NSString *prehandleToken;

@property (nonatomic, readwrite) BOOL buttonStatus;

/** 开始请求 */
- (void)startRequest;
/** 开始支付 */
- (void)startPayment;

@end
