//
//  CKRechargeModel.h
//  caiqr
//
//  Created by 任鹏杰 on 2017/4/28.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKBaseModel.h"

@interface CKRechargeModel : CKBaseModel

/**
 渠道列表
 */
@property (nonatomic, strong) NSMutableArray* channel_list;

/**
 选项数据
 */
@property (nonatomic, strong) NSArray* fill_list;

/**
 vip内容
 */
@property (nonatomic, strong) NSArray *big_moneny;

/**
 提现说明
 */
@property (nonatomic, strong) NSString *template_value;

/**
 最低充值限额
 */
@property (nonatomic, strong) NSArray *fill_limit_list;

@end
