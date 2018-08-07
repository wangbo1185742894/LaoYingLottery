//
//  SLMatchBetModel.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//  投注列表模型

#import "SLBaseModel.h"
#import <UIKit/UIKit.h>
@class SLMatchHistoryModel,SLSPFModel,SLBFModel,SLJPSModel,SLBQCModel;


@interface SLMatchBetModel : SLBaseModel

@property (nonatomic, strong) NSString *match_issue;

/**
 主队名
 */
@property (nonatomic, strong) NSString *host_name;

/**
 客队名
 */
@property (nonatomic, strong) NSString *away_name;

/**
 主队排名
 */
@property (nonatomic, strong) NSString *host_rank;

/**
 客队排名
 */
@property (nonatomic, strong) NSString *away_rank;

@property (nonatomic, strong) NSString *match_sn;

/**
 比赛日期(周几)
 */
@property (nonatomic, strong) NSString *match_week;

/**
 比赛时间
 */
@property (nonatomic, strong) NSString *match_time;

/**
 投注截止时间
 */
@property (nonatomic, strong) NSString *stop_sale_time;

/**
 联赛名
 */
@property (nonatomic, assign) NSInteger season_id;
@property (nonatomic, strong) NSString *season_pre;

@property (nonatomic, assign) NSInteger jingcai_match_id;

@property (nonatomic, assign) NSInteger wbai_match_id;

@property (nonatomic, assign) NSInteger result_status;

@property (nonatomic, assign) NSInteger top_type;

@property (nonatomic, strong) NSString *top_image;

/**
 spf开售状态
 */
@property (nonatomic, assign) NSInteger spf_sale_status;

/**
 rqspf开售状态
 */
@property (nonatomic, assign) NSInteger rqspf_sale_status;

/**
 bifen开售状态
 */
@property (nonatomic, assign) NSInteger bifen_sale_status;

/**
 bqc开售状态
 */
@property (nonatomic, assign) NSInteger bqc_sale_status;

/**
 jps开售状态
 */
@property (nonatomic, assign) NSInteger jqs_sale_status;

@property (nonatomic, assign) NSInteger spf_sport_status;
@property (nonatomic, assign) NSInteger bqc_sport_status;
@property (nonatomic, assign) NSInteger rqspf_sport_status;
@property (nonatomic, assign) NSInteger bf_sport_status;
@property (nonatomic, assign) NSInteger jqs_sport_status;

@property (nonatomic, strong) NSString *issue_time;


@property (nonatomic, strong) SLSPFModel *spf;

@property (nonatomic, strong) SLSPFModel *rqspf;

@property (nonatomic, strong) SLBFModel *bifen;

@property (nonatomic, strong) SLJPSModel *jqs;

@property (nonatomic, strong) SLBQCModel *bqc;

@property (nonatomic, strong) SLMatchHistoryModel *vs;

@property (nonatomic, strong) SLMatchHistoryModel *host;

@property (nonatomic, strong) SLMatchHistoryModel *away;

/**
 主队是否飘红
 */
@property (nonatomic, assign) NSInteger host_team_red_status;

/**
 客队是否飘红
 */
@property (nonatomic, assign) NSInteger away_team_red_status;

/**
 投注截止时间
 */
@property (nonatomic, strong) NSString *issue_time_desc;

@property (nonatomic, assign) NSInteger is_five_league;

/**
 历史战绩跳转地址
 */
@property (nonatomic, strong) NSString *bottom_url;


/**
 是否显示历史详情
 */
@property (nonatomic, assign, getter = isShowHistory) BOOL showHistory;


- (CGFloat)getOddsWithTag:(NSString *)tag;

@end
