//
//  SLDrawNoticeGroupModel.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/19.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLBaseModel.h"

@interface SLDrawNoticeGroupModel : SLBaseModel

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
