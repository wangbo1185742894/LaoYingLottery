//
//  CKThirdPayBoingWXStart.m
//  CKPayClient
//
//  Created by 洪利 on 2017/10/16.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CKThirdPayBoingWXStart.h"
#import <BoingPaySDK/Cashier.h> //头文件
@implementation CKThirdPayBoingWXStart
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isNeedHandleException = NO;
        self.channelID = CKThirdPayMentChannelIDBoingWechat;
    }
    return self;
}


- (void)configOrderInfoThanStartPayWithOrderInfo:(id)orderInfo amount:(NSNumber *)amount viewController:(UIViewController *)sourceViewController willStartPayMent:(void (^)())willStartPayment{
    NSDictionary *wxParameter = orderInfo[@"pay_info"]?:nil;
    !willStartPayment?:willStartPayment();
    NSString* token = [orderInfo objectForKey:@"token_id"];
    NSString* services = [orderInfo objectForKey:@"services"];
    //设置服务地址（非必须）
    //    [BoingPay setServerUrl:@"https://soa.boingpay.com"];
    //    //设置接口版本（非必须）
    //    [BoingPay setApiVersion:@"1.0"];
    //payToken  唤起超级收银台支付的支付令牌
    /*
     * channel:  传递支持的支付通道的键值
     *           //目前支持以下两种支付通道
     *           PAY_CHANNEL_ALIPAY 支付宝
     *           PAY_CHANNEL_WXPAY 微信
     */
    //controller  工程结构中必须有NavigationController这个导航控制器
    //paymentResult 通过超级收银台支付后的结果回调
    [Cashier createPayment:token options:@{@"channel":PAY_CHANNEL_ALIPAY} controller:sourceViewController paymentResult:^(NSString *resultCode, NSString *resultMsg) {
        if([@"succeed" isEqualToString:resultCode]){
            //支付成功
            //支付成功回调
            [self thirdPayFinish];
            NSLog(@"支付成功");
        }
        else if([@"failed" isEqualToString:resultCode]){
            //支付失败
            NSLog(@"支付失败，错误信息:%@",resultMsg);
        }
        else if([@"cancel" isEqualToString:resultCode]){
            //支付取消
        }
    }];
    NSLog(@"我是招商 微信支付");
}

@end
