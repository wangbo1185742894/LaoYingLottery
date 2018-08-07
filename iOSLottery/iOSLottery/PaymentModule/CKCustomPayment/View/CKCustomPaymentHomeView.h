//
//  CKCustomPaymentHomeView.h
//  CKPayClient
//
//  Created by 小铭 on 2017/5/5.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CKPayFlowFilter,CKPaymentBaseSource;
@interface CKCustomPaymentHomeView : UIView

+ (instancetype)CustomPaymentViewIsBuyRed:(BOOL)isRed preHandleToken:(NSString *)prehandleToken viewController:(UIViewController __weak *)pushController paymentActionBlock:(void(^)(CKPaymentBaseSource *,NSString *))paymentActionBlock;

@property (nonatomic, weak) UIViewController *pushController;

/**
 需要配置Source回调等Block 和 开始请求操作
 */
@property (nonatomic, copy) void(^paymentActionBlock)(CKPaymentBaseSource *,NSString *);

@property (nonatomic, strong) NSString *prehandleToken;

@property (nonatomic, readwrite) BOOL isRed;

@property (nonatomic, readwrite) BOOL buttonStatus;

/** 开始请求 */
- (void)startRequest;

/** 开始支付 */

- (void)startPayment;

@end

