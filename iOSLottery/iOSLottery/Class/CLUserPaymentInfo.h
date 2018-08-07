//
//  CLUserPaymentInfo.h
//  iOSLottery
//
//  Created by 小铭 on 2016/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"
@class CLUserPayAccountInfo,CLQuickRedPacketsModel;
@interface CLUserPaymentInfo : CLBaseModel

@property (nonatomic, strong) CLUserPayAccountInfo *pre_handle_token;
@property (nonatomic, strong) NSMutableArray *account_infos;
@property (nonatomic, strong) NSArray *default_account;
@property (nonatomic, strong) NSMutableArray <CLQuickRedPacketsModel *> *red_list;

/** 真票订单再支付请求返回数据 */
@property (nonatomic, strong) NSString* flow_id;
@property (nonatomic, strong) NSString* pay_for_token;
@property (nonatomic, assign) NSInteger pay_for_channel;
@property (nonatomic, assign) long long amount;
@property (nonatomic, assign) long long third_amount;
@property (nonatomic, readonly) BOOL isResetPayment;

/** 自定义字段 */
/** 跳转H5channelString */
@property (nonatomic, strong) NSString *backup_1;
@property (nonatomic, strong) NSString *backup_2;
@property (nonatomic, strong) NSString *backup_3;
@property (nonatomic, strong) NSString *backup_4;

@end
