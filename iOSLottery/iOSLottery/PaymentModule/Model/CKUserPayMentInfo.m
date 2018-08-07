//
//  CQUserPayMentInfo.m
//  caiqr
//
//  Created by 小铭 on 16/4/27.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CKUserPayMentInfo.h"
#import "CKUserCashBalanceInfo.h"
#import "CKUserRedPacketsModel.h"
#import "MJExtension.h"
@implementation CKUserPayMentInfo

+ (CKUserPayMentInfo*)userpaymentInfoCreateWith:(id)obj
{
    CKUserPayMentInfo* info  = [CKUserPayMentInfo objectWithKeyValues:obj];
    
    if (info.account_infos && info.account_infos.count > 0) {
        info->_isResetPayment = NO;
    } else {
        info->_isResetPayment = YES;
    }
    return info;
}

- (void)setAccount_infos:(NSArray *)account_infos
{
    _account_infos = [CKUserCashBalanceInfo objectArrayWithKeyValuesArray:account_infos];
//    [_account_infos.firstObject setIsSelected:YES];
    
}

- (void)setDefault_account:(NSArray *)default_account
{
    _default_account = [CKUserCashBalanceInfo objectArrayWithKeyValuesArray:default_account];
}

- (void)setRed_list:(NSArray *)red_list
{
    _red_list = [CKUserRedPacketsModel objectArrayWithKeyValuesArray:red_list];
}

@end


@implementation CKUserPayAccountInfo

@end
