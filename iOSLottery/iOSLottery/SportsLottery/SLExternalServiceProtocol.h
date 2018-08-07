//
//  SLExternalServiceProtocol.h
//  SportsLottery
//
//  Created by huangyuchen on 2017/6/1.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol SLExternalServiceProtocol <NSObject>

- (NSString *)getToken;

//toast 错误信息  需外部实现
- (void)showError:(NSString *)errorMes;
//加载动画
- (void)startLoading;
- (void)stopLoading;

//创建订单成功 去支付
- (void)createOrderSuccess:(id)orderInfo origin:(UIViewController *)originVC;

//继续支付创建订单成功 去支付
- (void)createContinueOrderSuccess:(id)orderInfo origin:(UIViewController *)originVC;

//去首页
- (void)goToHomeViewController;


- (void)goToFootBallViewController;

- (void)goToBasketBallViewController;

/**
 登录校验

 @param complete 完成回调
 */
- (void)checkIsLoginWithComplete:(void (^)())complete;

//分享中奖截图
- (void)shareMessageWithTitle:(NSString *)title tableView:(UITableView *)tableView;

//足球新手引导
- (void)showFootBallNewbieGuidance;

- (void)showBasketBallNewbieGuidance;

- (void)showRefundExplain;

- (BOOL)hasNet;
@end
