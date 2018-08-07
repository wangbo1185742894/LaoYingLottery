//
//  CQUserPayMentInfo.h
//  caiqr
//
//  Created by 小铭 on 16/4/27.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKCommonPaymentConf.h"

@class CKUserPayAccountInfo;
@class CKUserRedPacketsModel;
@interface CKUserPayMentInfo : NSObject

+ (CKUserPayMentInfo*)userpaymentInfoCreateWith:(id)obj;

@property (nonatomic, strong) CKUserPayAccountInfo *pre_handle_token;
@property (nonatomic, strong) NSArray *account_infos;
@property (nonatomic, strong) NSArray *default_account;
@property (nonatomic, strong) NSArray <CKUserRedPacketsModel *> *red_list;

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

@interface CKUserPayAccountInfo : NSObject
@property (nonatomic, strong) NSString *flow_id;
@property (nonatomic, strong) NSString *pay_for_token;
@property (nonatomic, strong) NSString *pay_for_channel;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *initiate_account_id;
@property (nonatomic, strong) NSString *transto_account_id;
@property (nonatomic, strong) NSString *handle_id;
@property (nonatomic, strong) NSString *operate_type_id;
@property (nonatomic, assign) long long amount;
@property (nonatomic, strong) NSString *memo;
@property (nonatomic, strong) NSString *operator_user;
@property (nonatomic, strong) NSString *operator_code;
@property (nonatomic, strong) NSString *trade_status;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *elapse_time;
@property (nonatomic, strong) NSString *update_time;
@property (nonatomic, strong) NSString *error_code;
@property (nonatomic, strong) NSString *module_id;
@property (nonatomic, assign) CKWXPaymentChannelType pay_channel_key;
/** 是否是标红状态 */
@property (nonatomic, readwrite) BOOL isMarkednessRed;
@property (nonatomic, strong) NSString *payAmountItemString;
//@property (nonatomic, strong) NSString *jj;
@end
