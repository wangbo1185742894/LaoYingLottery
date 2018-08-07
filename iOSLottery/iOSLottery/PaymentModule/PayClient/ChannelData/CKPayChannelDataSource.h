//
//  CKPayChannelDataSource.h
//  iOSLottery
//
//  Created by 彩球 on 17/4/14.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CKBaseModel.h"
#import <Foundation/Foundation.h>
#import "CKPayChannelFilterInterface.h"




@interface CKPayChannelDataSource : CKBaseModel <CKPaychannelDataInterface,NSCopying>


@property (nonatomic, strong) NSString* account_type_nm;
@property (nonatomic, assign) long long account_type_id;
@property (nonatomic, strong) NSString* account_id;
@property (nonatomic, strong) NSString* user_id;
@property (nonatomic, assign) double balance;
@property (nonatomic, strong) NSString* balancestr;

@property (nonatomic, assign) long long is_default_option;
@property (nonatomic, assign) long long status;
@property (nonatomic, assign) long long model_id;
@property (nonatomic, strong) NSString* use_priorty;
@property (nonatomic, assign) long long is_virtual;
@property (nonatomic, assign) long long is_withdrawal;
@property (nonatomic, assign) long long is_expense;
@property (nonatomic, assign) long long is_exchange;
@property (nonatomic, strong) NSString* unit;
@property (nonatomic, assign) long long is_direct;
@property (nonatomic, strong) NSString* img_url;
@property (nonatomic, assign) long long withdraw_fee;
@property (nonatomic, assign) long long fill_sales;
@property (nonatomic, assign) long long pay_for_sales;
@property (nonatomic, strong) NSString* memo;
@property (nonatomic, strong) NSString* backup_1;
@property (nonatomic, assign) long long highest_pay_amount;//支付上限
@property (nonatomic, assign) long long lowest_pay_amount;//支付下限
@property (nonatomic, strong) NSString* pay_url_code;
@property (nonatomic, assign) long long need_real_name;//需要实名认证
@property (nonatomic, assign) long long need_pay_pwd;//需要验证支付密码
@property (nonatomic, assign) long long need_card_bin;//需要验证卡前置
@property (nonatomic, strong) NSString* backup_8;
@property (nonatomic, strong) NSString* backup_9;
@property (nonatomic, strong) NSString* backup_10;


@property (nonatomic, strong) NSString* balanceStr;
@property (nonatomic) BOOL isVipChannel;




+ (CKPayChannelDataSource*) initOnlyRedPacketPayChannel;

@end
