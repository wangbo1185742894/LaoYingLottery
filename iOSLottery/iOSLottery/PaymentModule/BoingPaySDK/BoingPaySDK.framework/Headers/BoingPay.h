//
//  BoingPay.h
//  BoingPayDemo
//
//  Created by huck on 2017/3/20.
//  Copyright © 2017年 BoingPay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoingPay : NSObject

/**
 *  设置SDK的服务地址,不设置则使用默认服务地址,请在调用超级收银台前进行设置
 *
 *  @param serverUrl
 */
+ (void)setServerUrl:(NSString *)serverUrl;

/**
 *  设置SDK的接口版本,不设置则使用默认@"1.0"
 *
 *  @param version
 */
+ (void)setApiVersion:(NSString *)version;
@end
