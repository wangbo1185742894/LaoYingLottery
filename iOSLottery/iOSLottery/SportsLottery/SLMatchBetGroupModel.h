//
//  SLMatchBetGroupModel.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/16.
//  Copyright © 2017年 caiqr. All rights reserved.
//  投注列表组模型

#import "SLBaseModel.h"

@interface SLMatchBetGroupModel : SLBaseModel
/**
 区头标题
 */
@property (nonatomic, strong) NSString *title;
/**
 模型数组
 */
@property (nonatomic, strong) NSMutableArray *matches;

@property (nonatomic, assign) long long add_top;
/**
 是否展开分组
 */
@property (nonatomic, assign,getter = isVisible) BOOL visible;

@end
