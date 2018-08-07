//
//  CLPaymentChannelInfo.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/12.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLPaymentChannelInfo.h"

@implementation CLPaymentChannelInfo

- (void)setAccount_type_id:(paymentChannelType)account_type_id {
    
    _account_type_id = account_type_id;
    
    if (account_type_id == paymentChannelTypeWx) {
        self.payLimitAmount = 2;
    } else if (account_type_id == paymentChannelTypeAccountBalance) {
        self.payLimitAmount = 10;
    } else {
        self.payLimitAmount = 0;
    }
}

- (id)copyWithZone:(NSZone *)zone{
    
    CLPaymentChannelInfo * channalInfo = [[[self class] allocWithZone:zone] init];
    
    channalInfo.account_id = self.account_id;
    channalInfo.account_type_id = self.account_type_id;
    channalInfo.account_type_nm = self.account_type_nm;
    channalInfo.backup_1 = self.backup_1;
    channalInfo.backup_2 = self.backup_2;
    channalInfo.backup_3 = self.backup_3;
    channalInfo.backup_4 = self.backup_4;
    channalInfo.balance = self.balance;
    channalInfo.balancestr = self.balancestr;
    channalInfo.fill_sales = self.fill_sales;
    channalInfo.img_url = self.img_url;
    channalInfo.is_default_option = self.is_default_option;
    channalInfo.is_direct = self.is_direct;
    channalInfo.is_exchange = self.is_exchange;
    channalInfo.is_virtual = self.is_virtual;
    channalInfo.is_withdrawal = self.is_withdrawal;
    channalInfo.memo = self.memo;
    channalInfo.model_id = self.model_id;
    channalInfo.pay_for_sales = self.pay_for_sales;
    channalInfo.status = self.status;
    channalInfo.unit = self.unit;
    channalInfo.use_priorty = self.use_priorty;
    channalInfo.user_id = self.user_id;
    channalInfo.withdraw_fee = self.withdraw_fee;
    channalInfo.payLimitAmount = self.payLimitAmount;
    channalInfo.isSelected = self.isSelected;
    channalInfo.isUnused = self.isUnused;
    return channalInfo;
}



@end
