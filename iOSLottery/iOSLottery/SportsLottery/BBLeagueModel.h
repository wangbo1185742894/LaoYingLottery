//
//  BBLeagueModel.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//  篮球 联赛模型

#import "SLBaseModel.h"

@interface BBLeagueModel : SLBaseModel<NSCopying, NSMutableCopying>

/**
 联赛id
 */
@property (nonatomic, assign) NSInteger seasionId;

/**
 联赛名
 */
@property (nonatomic, strong) NSString *titile;

/**
 是否选中
 */
@property (nonatomic, assign) BOOL isSelect;

/**
 联赛总场次
 */
@property (nonatomic, assign) NSInteger leagueTotal;

@end
