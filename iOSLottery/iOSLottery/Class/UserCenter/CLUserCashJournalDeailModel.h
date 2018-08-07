//
//  CLUserCashJournalDeailModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/25.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

typedef NS_ENUM(NSInteger,UserCashBalanceDetailType)
{
    UserCashBalanceDefault = 0,
    UserCashBalanceOrderPayMent = 1001,         /** 投注 */
    UserCashBalanceOrderWithdraw = 1002,        /* 提现 */
    UserCashBalanceOrderBuyRedEnvelop = 1006,   /* 买红包 */
    UserCashBalanceOrderReturnAward = 2002,     /** 返奖 */
    UserCashBalanceOrderRefund = 2003,           /** 退款 */
    UserCashBalanceOrderRecharge = 2007,        /* 充值 */
};

@interface CLUserCashJournalDeailModel : CLBaseModel

@property (nonatomic, strong) NSString *flow_id;
@property (nonatomic, strong) NSString *type_name;
@property (nonatomic, assign) UserCashBalanceDetailType operate_type_id;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *memo;
@property (nonatomic, strong) NSArray *memo_array;

@property (nonatomic, strong) NSString *handle_id;
@property (nonatomic, strong) NSString *times;
@property (nonatomic, strong) NSString *create_date;
@property (nonatomic, strong) NSString *create_time;

@end
