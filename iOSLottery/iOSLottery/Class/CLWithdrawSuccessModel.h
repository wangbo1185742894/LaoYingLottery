//
//  CLWithdrawSuccessModel.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/29.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"
@class CLUserCashWithdrawOrderModelInfo;

@interface CLWithdrawSuccessModel : CLBaseModel

@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *memo;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *elapse_time;
@property (nonatomic, strong) NSString *update_time;

@property (nonatomic, strong) NSString *flow_id;
@property (nonatomic, strong) NSString *handle_id;
@property (nonatomic, strong) NSString *initiate_account_id;
@property (nonatomic, strong) NSString *module_id;
@property (nonatomic, strong) NSString *operate_type_id;
@property (nonatomic, strong) NSString *operator_code;
@property (nonatomic, strong) NSString *operator_user;

@property (nonatomic, strong) NSString *pay_for_channel;
@property (nonatomic, strong) NSString *pay_for_token;

@property (nonatomic, strong) NSString *trade_status;

@property (nonatomic, strong) NSString *transto_account_id;

@property (nonatomic, strong) CLUserCashWithdrawOrderModelInfo *order_info;

@property (nonatomic, strong) NSString *error_code;

@end

@interface CLUserCashWithdrawOrderModelInfo : CLBaseModel

@property (nonatomic, strong) NSString *user_id;

@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *order_status;
@property (nonatomic, strong) NSString *order_type;

@property (nonatomic, strong) NSString *ratify_status;
@property (nonatomic, strong) NSString *update_time;

@property (nonatomic, strong) NSArray *channel_info;
@property (nonatomic, strong) NSString *channel_type;

@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *elapse_time;

@property (nonatomic, strong) NSString *err_msg;
@property (nonatomic, strong) NSString *error_code;

@property (nonatomic, strong) NSString *handle_batch;
@property (nonatomic, strong) NSString *handle_date;

@property (nonatomic, assign) BOOL no_pass_reason;


@end

//** 用户流水memoModel */
@interface CLUserCashBalanceMemo : CLBaseModel

+ (instancetype)createUserCashBalanceMemoModelWithDic:(NSDictionary *)dic;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, readwrite) BOOL isDefault;
@property (nonatomic, strong) NSArray *orderInfoArr;
@end
