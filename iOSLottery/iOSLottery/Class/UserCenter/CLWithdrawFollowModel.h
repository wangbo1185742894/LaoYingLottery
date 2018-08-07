//
//  CLWithdrawFollowModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/13.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

@interface CLWithdrawFollowModel : CLBaseModel

@property (nonatomic, strong) NSString* bank_short_name;
@property (nonatomic, strong) NSString * amount;
@property (nonatomic, strong) NSString* card_no;
@property (nonatomic, strong) NSString* create_data;
@property (nonatomic, strong) NSString* create_datas;
@property (nonatomic, strong) NSString* create_time;
@property (nonatomic, strong) NSString* day_over;
@property (nonatomic, strong) NSString* fee_str;
@property (nonatomic, strong) NSString* order_id;
@property (nonatomic) BOOL order_status;
@property (nonatomic) NSInteger ratify_status;
@property (nonatomic, strong) NSArray* ratify_status_group;
@property (nonatomic, strong) NSString* ratify_status_str;
@property (nonatomic, strong) NSString* times;

@end
