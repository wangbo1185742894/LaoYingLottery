//
//  CLPayMentService.h
//  iOSLottery
//
//  Created by 小铭 on 2016/12/19.
//  Copyright © 2016年 caiqr. All rights reserved.
//  支付PaymentService

#import <Foundation/Foundation.h>
@class CLUserPaymentInfo;
@interface CLPayMentService : NSObject

@property (nonatomic, strong) CLUserPaymentInfo *paymentInfo;
/** 是否是快速支付 */
@property (nonatomic, readwrite) BOOL isQuickPayment;
/** 支付方式index */
@property (nonatomic, assign) NSInteger channelIndex;
/** 选择红包index */
@property (nonatomic, assign) NSInteger redSelectedIndex;
/** 支付金额 */
@property (nonatomic, assign) long long needPayAmount;

@property (nonatomic, assign) NSInteger payChannelID;

@property (nonatomic, strong) id customObj;
/** 账户余额 */
- (long long)userBalance;
/** 支付方式 */
- (NSArray *)paymentArr;
/** 红包数组 */
- (NSArray *)redModelArr;
/** 更新支付方式 */
- (void)changePaychannelWith:(id)payMentModel;
/** 更新红包 */
- (void)changeRedModelWith:(id)redModel;
/** 支付数据源 自带更换支付方式 */
- (NSArray *)paymentDataSource;

@end
