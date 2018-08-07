//
//  CKPayMentInfoModel.m
//  caiqr
//
//  Created by huangyuchen on 2017/4/27.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKPayMentInfoModel.h"

@implementation CKPayMentInfoModel

+ (NSDictionary *)objectClassInArray{
    
    return @{@"default_account" : @"CKPayChannelDataSource", @"account_infos" : @"CKPayChannelDataSource", @"red_list" : @"CKRedPacketDataSource", @"big_moneny" : @"CKPayChannelDataSource"};
}

@end
