//
//  CQUserRedPacketsModel.h
//  caiqr
//
//  Created by 小铭 on 16/4/18.
//  Copyright © 2016年 Paul. All rights reserved.
//  用户红包余额列表cell模型

#import <Foundation/Foundation.h>

@interface CKUserRedPacketsModel : NSObject
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


@interface CKUserRedPacketsDetailModel : NSObject

@property (nonatomic, strong) NSString *red_balance;
@property (nonatomic, strong) NSArray *red_table;
@property (nonatomic, assign) BOOL red_status;
@property (nonatomic, strong) NSDictionary *red_button;

@end


