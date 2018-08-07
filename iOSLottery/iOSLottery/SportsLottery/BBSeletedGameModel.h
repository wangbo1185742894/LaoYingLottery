//
//  BBSeletedGameModel.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//  选中的每场比赛 模型

#import "SLBaseModel.h"

@class BBSelectPlayMethodInfo;

@interface BBSeletedGameModel : SLBaseModel

@property (nonatomic, strong) NSString *matchIssue;


@property (nonatomic, strong) BBSelectPlayMethodInfo *sfInfo;

@property (nonatomic, strong) BBSelectPlayMethodInfo *rfsfInfo;

@property (nonatomic, strong) BBSelectPlayMethodInfo *dxfInfo;

@property (nonatomic, strong) BBSelectPlayMethodInfo *sfcInfo;

- (void)setOnePlayMethodWith:(BBSelectPlayMethodInfo *)info;

- (NSString *)getCreadOrderString;

@end


//每一个玩法选中的投注项
@interface BBSelectPlayMethodInfo : NSObject

/**
 玩法
 */
@property (nonatomic, strong) NSString *playMothed;

/**
 当前玩法是否支持单关
 */
@property (nonatomic, assign) BOOL isDanGuan;

/**
 让分数
 */
@property (nonatomic, strong) NSString * rangFenCount;

/**
 当前玩法选中的选项
 */
@property (nonatomic, strong) NSMutableArray *selectPlayMothedArray;

@end
