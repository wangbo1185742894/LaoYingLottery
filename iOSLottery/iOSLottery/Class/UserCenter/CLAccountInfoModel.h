//
//  CLAccountInfoModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/25.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"
#import "CLPaymentConfig.h"
@interface CLAccountInfoModel : CLBaseModel

@property (nonatomic, strong) NSString *account_type_nm;
@property (nonatomic, assign) NSInteger account_type_id;
@property (nonatomic, assign) paymentChannelType account_id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, assign) double balance;
@property (nonatomic, strong) NSString *balancestr;
@property (nonatomic, assign) BOOL is_default_option;
@property (nonatomic, assign) BOOL status;
@property (nonatomic, strong) NSString *model_id;
@property (nonatomic, assign) BOOL use_priorty;
@property (nonatomic, assign) BOOL is_virtual;
@property (nonatomic, assign) BOOL is_withdrawal;
@property (nonatomic, assign) BOOL is_expense;
@property (nonatomic, assign) BOOL is_exchange;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, assign) BOOL is_direct;
@property (nonatomic, strong) NSString *img_url;
@property (nonatomic, strong) NSString *withdraw_fee;
@property (nonatomic, strong) NSString *fill_sales;
@property (nonatomic, strong) NSString *pay_for_sales;
@property (nonatomic, strong) NSString *memo;


@property (nonatomic, strong) NSString *backup_1;
@property (nonatomic, strong) NSString *backup_2;
@property (nonatomic, strong) NSString *backup_3;
@property (nonatomic, strong) NSString *backup_4;

/** custom */

@property (nonatomic, assign) long long minLimit;
@property (nonatomic, assign) long long  maxLimit;

@property (nonatomic, readwrite) BOOL isDefault;

@property (nonatomic, readwrite) BOOL useStatus;

@property (nonatomic, readwrite) BOOL selectedStatus;

@end
