//
//  CKPayHandleModel.h
//  caiqr
//
//  Created by huangyuchen on 2017/4/27.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKBaseModel.h"

@interface CKPayHandleModel : CKBaseModel

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

@end
