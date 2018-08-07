//
//  CLWithdrawInfoModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/13.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

@class CLWithdrawAccountInfo,CLWithdrawList;

@interface CLWithdrawInfoModel : CLBaseModel

@property (nonatomic, strong) CLWithdrawAccountInfo* account_info;
@property (nonatomic, strong) NSMutableArray* withdraw_list;

@end

@interface CLWithdrawAccountInfo : CLBaseModel

@property (nonatomic) long long balance;
@property (nonatomic, strong) NSString* balancestr;
@property (nonatomic, strong) NSString* withdraw_message;
@property (nonatomic) NSInteger withdraw_cnt;

@end

@interface CLWithdrawList : CLBaseModel

@property (nonatomic, strong) NSString* card_code;
@property (nonatomic, strong) NSArray* channel_infos;
@property (nonatomic) NSInteger channel_type;
@property (nonatomic, strong) NSString* create_user;
@property (nonatomic, strong) NSString* real_name;

@property (nonatomic) BOOL isNull;

@end



