//
//  CLUserPaymentInfo.m
//  iOSLottery
//
//  Created by 小铭 on 2016/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLUserPaymentInfo.h"
#import "CLQuickRedPacketsModel.h"
#import "CLUserPayAccountInfo.h"
#import "CLAccountInfoModel.h"
@implementation CLUserPaymentInfo

+ (NSDictionary *)objectClassInArray{
    
    return @{@"default_account" : @"CLAccountInfoModel", @"account_infos" : @"CLAccountInfoModel", @"pre_handle_token" : @"CLUserPayAccountInfo", @"red_list" : @"CLQuickRedPacketsModel"};
}

//- (void)setDefault_account:(NSArray *)default_account
//{
//    _default_account = [CLAccountInfoModel objectArrayWithKeyValuesArray:default_account];
//}
//
//- (void)setAccount_infos:(NSMutableArray *)account_infos
//{
//    _account_infos = [CLAccountInfoModel objectArrayWithKeyValuesArray:account_infos];
//}
//
//- (void)setPre_handle_token:(CLUserPayAccountInfo *)pre_handle_token
//{
//    _pre_handle_token = [CLUserPayAccountInfo objectWithKeyValues:pre_handle_token];
//}
//
//- (void)setRed_list:(NSMutableArray<CLQuickRedPacketsModel *> *)red_list
//{
//    _red_list = [CLQuickRedPacketsModel objectArrayWithKeyValuesArray:red_list];
//}

@end

