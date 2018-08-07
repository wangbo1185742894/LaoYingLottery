//
//  CQUserRedPacketsNewModel.h
//  caiqr
//
//  Created by huangyuchen on 2016/10/18.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CLBaseModel.h"
@class CQUserRedPacketsMemoModel;
@class CQUserRedPacketsListModel;
@interface CQUserRedPacketsNewModel : CLBaseModel

@property (nonatomic, strong) NSString *red_balance;//红包总余额
@property (nonatomic, strong) CQUserRedPacketsMemoModel *red_memo;//其中9元将过期
@property (nonatomic, strong) NSString *red_ad_img;
@property (nonatomic, strong) NSString *red_ad_url;
@property (nonatomic, strong) NSString *red_ad_content;
@property (nonatomic, strong) NSArray *no_red_content;//无数据时显示文案
@property (nonatomic, strong) NSArray<CQUserRedPacketsListModel *> *red_list;
@property (nonatomic, strong) NSString *show_more;
@property (nonatomic, strong) NSString *page;

@end
#pragma mark ------ 红包列表 list ------
@interface CQUserRedPacketsListModel : CLBaseModel

@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) NSString *balance;
@property (nonatomic, strong) NSString *red_amount;
@property (nonatomic, assign) long balance_num;
@property (nonatomic, strong) NSString *red_name;
@property (nonatomic, strong) NSString *pay_name;
@property (nonatomic, strong) NSString *show_name;
@property (nonatomic, assign) long red_recommend;
@property (nonatomic, strong) NSString *red_line_color;
@property (nonatomic, strong) NSString *red_left_date_color;
@property (nonatomic, strong) NSString *red_memo;
@property (nonatomic, assign) long red_flg;
@property (nonatomic, strong) NSString *red_left_date;

@end
#pragma mark ------ 其中9元将过期的model ------
@interface CQUserRedPacketsMemoModel : CLBaseModel
@property (nonatomic, strong) NSString *memo;
@property (nonatomic, strong) NSString *color;
@end







