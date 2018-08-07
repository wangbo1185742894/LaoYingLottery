//
//  BBDrawNoticeGroupModel.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/11.
//  Copyright © 2017年 caiqr. All rights reserved.
//  篮球开奖公告 组模型

#import "SLBaseModel.h"

@interface BBDrawNoticeGroupModel : SLBaseModel

/**
 区头标题
 */
@property (nonatomic, strong) NSString *msg;

/**
 模型数组
 */
@property (nonatomic, strong) NSMutableArray *noticeInfo;

/**
 当前组是否有数据
 */
@property (nonatomic, assign, getter=isNoData) BOOL noData;

/**
 是否展开分组
 */
@property (nonatomic, assign,getter = isVisible) BOOL visible;

@end
