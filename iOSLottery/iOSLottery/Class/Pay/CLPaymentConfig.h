//
//  CLPaymentConfig.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#ifndef CLPaymentConfig_h
#define CLPaymentConfig_h


typedef NS_ENUM(NSInteger, paymentChannelType)
{
    paymentChannelTypeOnlyRedParkets = -1,
    paymentChannelTypeAccountBalance = 1,
    paymentChannelTypeUPPay = 3,
    paymentChannelTypeAliPay = 4,
    paymentChannelTypeWx = 5,
    paymentChannelTypeLianLian = 6,
    paymentChannelTypeYiBao = 8,
    paymentChannelTypeYiLian = 9,
    paymentChannelTypeSupportCardPreposing = 30,
    paymentChannelTypeOther = 999
};


#endif /* CLPaymentConfig_h */
