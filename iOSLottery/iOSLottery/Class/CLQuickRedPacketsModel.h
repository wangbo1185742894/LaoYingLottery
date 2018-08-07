//
//  CLQuickRedPacketsModel.h
//  iOSLottery
//
//  Created by 小铭 on 2016/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//  快速支付 红包选择模型

#import "CLBaseModel.h"

@interface CLQuickRedPacketsModel : CLBaseModel

@property (nonatomic, strong) NSString *balance;
//** 真票支付页红包模型添加 */
@property (nonatomic, assign) long long balance_num;
@property (nonatomic, strong) NSString *red_name;
@property (nonatomic, strong) NSString *pay_name;
@property (nonatomic, strong) NSString *show_name;
@property (nonatomic, strong) NSString *red_line_color;
@property (nonatomic, strong) NSString *red_left_date_color;
@property (nonatomic, strong) NSString *red_left_date;
@property (nonatomic, strong) NSString *fid;
/** 推荐红包 */
@property (nonatomic, readwrite) BOOL red_recommend;

//** 选择状态 */
@property (nonatomic, readwrite) BOOL isSelected;
/** 不选择红包标识 */
@property (nonatomic, readwrite) BOOL noRedSelected;
//红包总额
@property (nonatomic, strong) NSString *red_amount;

@end
