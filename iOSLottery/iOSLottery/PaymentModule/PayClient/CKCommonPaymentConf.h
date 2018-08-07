//
//  CQCommonPaymentConf.h
//  caiqr
//
//  Created by 彩球 on 16/5/3.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CKPaymentChannelType)
{
    CKPaymentChannelTypeOnlyRedParkets = 0,
    CKPaymentChannelTypeAccountBalance = 1,
    CKPaymentChannelTypeUPPay = 3,
    CKPaymentChannelTypeAliPay = 4,
    CKPaymentChannelTypeWx = 5,
    CKPaymentChannelTypeLianLian = 6,
    CKPaymentChannelTypeYiBao = 8,
    CKPaymentChannelTypeYiLian = 9,
    CKPaymentChannelTypeSupportCardPreposing = 30,
    CKPaymentChannelTypeOther = 999
};

typedef NS_ENUM(NSInteger, CKWXPaymentChannelType)
{
    CKWXPaymentDefault = 0,
    /** 汇元微信支付 */
    CKWXPaymentHeepay = 501,
    /** 梓微兴微信支付 */
    CKWXPaymentZwxpay = 502,
    /** 派洛贝微信支付 跳转SDK */
    CKWXPaymentPeralppay = 503
};

@interface CKCommonPaymentConf : NSObject



@end
