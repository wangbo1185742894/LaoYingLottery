//
//  CLPaymentConfigureModel.h
//  iOSLottery
//
//  Created by 小铭 on 2016/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//  支付配置模型

#import "CLBaseModel.h"

@interface CLPaymentConfigureModel : CLBaseModel

@property (nonatomic, strong) NSString* order_id;
@property (nonatomic, strong) NSString* order_fail_time;
@property (nonatomic, strong) NSString* pre_handle_token;
@property (nonatomic, strong) NSString* account_type_name;
@property (nonatomic, assign) NSInteger account_type_id;
@property (nonatomic, assign) double balance;
@property (nonatomic, assign) NSInteger task_enabled;
@property (nonatomic, strong) NSString* task_title;
@property (nonatomic, assign) NSInteger amount;

@end
