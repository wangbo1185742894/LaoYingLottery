//
//  SLBetInfoCache.h
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/16.
//  Copyright © 2017年 caiqr. All rights reserved.
// 所有数据的缓存   包括投注项  比赛信息  筛选的比赛

#import <Foundation/Foundation.h>
#import "SLBetSelectInfo.h"
#import "SLMatchBetGroupModel.h"
#import "SLMatchSelectModel.h"
#import "SLBetSelectInfo.h"
@interface SLBetInfoCache : NSObject

+ (instancetype)shareBetInfoCache;

/**
 用户选中的所有投注项
 */
@property (nonatomic, strong) SLBetSelectInfo *allSelectBetItem;


/**
 足球 不同玩法的gameId  (单关  串关  混合投注等)
 */
@property (nonatomic, strong) NSNumber *jczq_mix_p;

/**
 最大倍数
 */
@property (nonatomic, assign) long long maxTimes;

/**
 所有比赛数据
 */
@property (nonatomic, strong) NSMutableArray<SLMatchBetGroupModel *> *allMatchsArray;


/**
 共有多少组联赛
 */
@property (nonatomic, strong) NSMutableArray<SLMatchSelectModel *> *leagueMatchesArray;


/**
 筛选出的所有比赛数据
 */
@property (nonatomic, strong) NSMutableArray *allFilterMatchArray;


@end
