//
//  CKRedPacketDataSource.h
//  iOSLottery
//
//  Created by 彩球 on 17/4/13.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKRedPacketFilterInterface.h"

@interface CKRedPacketDataSource : NSObject <CKRedPacketDataSourceInterface>

@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) NSString *balance;
//红包总额
@property (nonatomic, strong) NSString *red_amount;
//** 真票支付页红包模型添加 */
@property (nonatomic, assign) long long balance_num;
@property (nonatomic, strong) NSString *red_name;
@property (nonatomic, strong) NSString *pay_name;
@property (nonatomic, strong) NSString *show_name;
/** 推荐红包 */
@property (nonatomic, readwrite) BOOL red_recommend;
@property (nonatomic, strong) NSString *red_line_color;
@property (nonatomic, strong) NSString *red_left_date_color;
@property (nonatomic, strong) NSString *red_memo;
@property (nonatomic, assign) long long red_flg;
@property (nonatomic, strong) NSString *red_left_date;

@property (nonatomic, strong) NSString *red_effective_date;
@property (nonatomic, assign) long long used_play_type;
@property (nonatomic, strong) NSString *used_play_type_text;
@property (nonatomic, assign) long long red_type;

@property (nonatomic, strong) NSString* name;
@property (nonatomic) BOOL is_select_option;
@end
