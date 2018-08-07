//
//  BBDrawNoticeModel.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/11.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLBaseModel.h"

@interface BBDrawNoticeModel : SLBaseModel

/**
 联赛名
 */
@property (nonatomic, strong) NSString *leagueMatches;

/**
 场次
 */
@property (nonatomic, strong) NSString *matchIssue;

/**
 期次
 */
@property (nonatomic, strong) NSString *periodId;

/**
 比赛开始时间
 */
@property (nonatomic, strong) NSString *matchStartTime;

/**
 主队名
 */
@property (nonatomic, strong) NSString *hostName;

/**
 客队名
 */
@property (nonatomic, strong) NSString *awayName;

/**
 全场比分
 */
@property (nonatomic, strong) NSString *score;

/**
 半场比分
 */
@property (nonatomic, strong) NSString *halfScore;

/**
 比分颜色
 */
@property (nonatomic, strong) NSString *matchResults;

/**
 开奖结果/开奖赔率
 */
@property (nonatomic, strong) NSArray *awardSp;

/**
 赛事是否取消
 */
@property (nonatomic, assign) NSInteger isCancel;

/**
 模型对应的cell的类名
 */
@property (nonatomic, strong) NSString *cellClassName;

@property (nonatomic, strong) Class className;

@end
