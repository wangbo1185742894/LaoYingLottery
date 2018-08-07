//
//  CLPaymentChannelInfo.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/12.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"
#import "CLPaymentConfig.h"

@interface CLPaymentChannelInfo : CLBaseModel

@property (nonatomic, strong) NSString* account_id;
@property (nonatomic) paymentChannelType account_type_id;
@property (nonatomic, strong) NSString* account_type_nm;
@property (nonatomic, strong) NSString* backup_1;
@property (nonatomic, strong) NSString* backup_2;
@property (nonatomic, strong) NSString* backup_3;
@property (nonatomic, strong) NSString* backup_4;
@property (nonatomic, strong) NSString* balance;
@property (nonatomic, strong) NSString* balancestr;
@property (nonatomic) NSInteger fill_sales;
@property (nonatomic, strong) NSString* img_url;
@property (nonatomic) NSInteger is_default_option;
@property (nonatomic) NSInteger is_direct;
@property (nonatomic) NSInteger is_exchange;
@property (nonatomic) NSInteger is_expense;
@property (nonatomic) NSInteger is_virtual;
@property (nonatomic) NSInteger is_withdrawal;
@property (nonatomic, strong) NSString* memo;
@property (nonatomic) NSInteger model_id;
@property (nonatomic) NSInteger pay_for_sales;
@property (nonatomic) NSInteger status;
@property (nonatomic, strong) NSString* unit;
@property (nonatomic) NSInteger use_priorty;
@property (nonatomic, strong) NSString* user_id;
@property (nonatomic) NSInteger withdraw_fee;

//custom
@property (nonatomic) double payLimitAmount;


@property (nonatomic) BOOL isSelected;
@property (nonatomic) BOOL isUnused;

@end
