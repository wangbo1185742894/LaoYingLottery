//
//  Cashier.h
//  BoingPayDemo
//
//  Created by huck on 2017/1/16.
//  Copyright © 2017年 BoingPay. All rights reserved.
//

/**
 *boingpay超级收银台接口
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//无界面支付option参数的key和value
#define PAY_CHANNEL_KEY    @"channel"
#define PAY_CHANNEL_ALIPAY @"alipay"
#define PAY_CHANNEL_WXPAY  @"wxpay"

@interface Cashier : NSObject

/**
 *  处理支付结果的回调，在 AppDelegate中的
 *   - (BOOL)application:(UIApplication *)application
 *           openURL:(NSURL *)url
 *           sourceApplication:(NSString *)sourceApplication
 *           annotation:(id)annotation
 *   方法中回调
 *  @param resultUrl
 */
+ (BOOL)handlePaymentResultUrl:(NSURL *)resultUrl;

/**
 *  调用Cashier超级收银台进行支付
 *
 *  @param payToken  唤起超级收银台支付的支付令牌（带有用户订单信息的json格式的字符串）
 *  @param controller  工程结构中必须有NavigationController这个导航控制器 controller.navigationController
 *  @param paymentResult 通过超级收银台支付后的结果回调，其中resultCode值包括 "succeed"(支付成功) "failed"(支付失败) "cancel"(支付取消)  resultMsg为对应的结果信息
 */
+ (void)createPayment:(NSString*)payToken controller:( UIViewController *)controller paymentResult:(void(^)(NSString *resultCode,NSString *resultMsg))paymentResult;


/**
 *  调用Cashier超级收银台进行支付,无界面立即支付
 *
 *  @param payToken  唤起超级收银台支付的支付令牌（带有用户订单信息的json格式的字符串）
 *  @param options  实现用户无界面调用的参数,目前支持调用支付宝和微信,传递参数为 @{@"channel",PAY_CHANNEL_ALIPAY} 或者 @{@"channel",PAY_CHANNEL_WXPAY}
 *  @param controller  工程结构中必须有NavigationController这个导航控制器 controller.navigationController
 *  @param paymentResult 通过超级收银台支付后的结果回调，其中resultCode值包括 "succeed"(支付成功) "failed"(支付失败) "cancel"(支付取消)  resultMsg为对应的结果信息
 */
+ (void)createPayment:(NSString*)payToken options:(NSDictionary *)options controller:( UIViewController *)controller paymentResult:(void(^)(NSString *resultCode,NSString *resultMsg))paymentResult;


/**超级收银台的导航栏样式设置，如果有需要，请在调起 createPayment:paymentResult: 方法前进行设置**/
/**
 *  设置超级收银台的导航栏的tint颜色，影响到回退按钮的颜色和标题的颜色，默认为白的
 *
 *  @param tintColor
 */
+ (void)setCashierTintColor:(UIColor *)tintColor;

/**
 *  设置超级收银台的导航栏背景条颜色 默认为#434552
 *
 *  @param navBgColor
 */
+ (void)setCashierNavigationBgColor:(UIColor *)navBgColor;

/**
 *  设置超级收银台的导航栏title中的图标是否显示，默认为不显示
 *
 *  @param navBgColor
 */
+ (void)setCashierTitleIconShow:(BOOL)show;


@end
