//
//  BBMatchGroupModel.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//  篮球 投注 组模型

#import "SLBaseModel.h"

@interface BBMatchGroupModel : SLBaseModel

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
