//
//  CQUserCashBalanceInfo.h
//  caiqr
//
//  Created by 小铭 on 16/4/13.
//  Copyright © 2016年 Paul. All rights reserved.
//  账户余额列表和提现列表相关信息，包括个人信息

#import <Foundation/Foundation.h>

@interface CKUserCashBalanceInfo : NSObject


@property (nonatomic, assign) BOOL cantUseThisChannerToPay;//是否不支持此种方式支付
@property (nonatomic, strong) NSString *unSupportReasonably;//余额不足时展示
@property (nonatomic, strong) NSString *account_type_nm;
@property (nonatomic, assign) NSInteger account_type_id;
@property (nonatomic, strong) NSString *account_id;
@property (nonatomic, strong) NSString *user_id;
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
@property (nonatomic, strong) NSArray *memo;
/** 自定义字段 */
/** 跳转H5channelString */
@property (nonatomic, strong) NSString *backup_1;
@property (nonatomic, strong) NSString *backup_2;
@property (nonatomic, strong) NSString *backup_3;
@property (nonatomic, strong) NSString *backup_4;
//** 提现列表多配置属性 */
@property (nonatomic, assign) double balance;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, readwrite) BOOL noEnoungthBalance;
@end
