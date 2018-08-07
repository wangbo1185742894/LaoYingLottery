//
//  SLExternalService.h
//  SportsLottery
//
//  Created by huangyuchen on 2017/6/1.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLExternalServiceProtocol.h"
@interface SLExternalService : NSObject

+ (instancetype)sl_ShareExternalService;

@property (nonatomic, strong) id <SLExternalServiceProtocol> externalService;

+ (NSString *)getToken;

//toast 错误信息  需外部实现
+ (void)showError:(NSString *)errorMes;
//加载动画
+ (void)startLoading;
+ (void)stopLoading;

//创建订单成功 去支付
+ (void)createOrderSuccess:(id)orderInfo origin:(UIViewController *)originVC;

+ (void)createContinueOrderSuccess:(id)orderInfo origin:(UIViewController *)originVC;

+ (void)checkIsLoginWithComplete:(void (^)())complete;

//分享中奖截图
+ (void)shareMessageWithTitle:(NSString *)title tableView:(UITableView *)tableView;

+ (void)showFootBallNewbieGuidance;

+ (void)showBasketBallNewbieGuidance;

+ (void)showRefundExplain;

/**
 是否有网

 @return bool
 */
+ (BOOL)hasNet;

+ (void)goToHomeViewController;

+ (void)goToFootBallViewController;

+ (void)goToBasketBallViewController;

@end
