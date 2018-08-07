//
//  BBMatchModel.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLBaseModel.h"
#import <UIKit/UIKit.h>

@class BBSFModel,BBRFSFModel,BBDXFModel,BBSFCModel,SLMatchHistoryModel;

@interface BBMatchModel : SLBaseModel



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

/**
 赛事编号
 */
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
 ??
 */
@property (nonatomic, strong) NSString *issue_time;

/**
 投注截止时间
 */
@property (nonatomic, strong) NSString *stop_sale_time;

/**
 联赛id
 */
@property (nonatomic, assign) NSInteger season_id;

/**
 联赛名
 */
@property (nonatomic, strong) NSString *season_pre;

@property (nonatomic, assign) NSInteger jingcai_match_id;

@property (nonatomic, assign) NSInteger wbai_match_id;

@property (nonatomic, assign) NSInteger result_status;

@property (nonatomic, assign) NSInteger top_type;

@property (nonatomic, strong) NSString *top_image;

/**
 胜平负开售状态
 */
@property (nonatomic, assign) NSInteger sf_sale_status;

/**
 让分胜平负开售状态
 */
@property (nonatomic, assign) NSInteger rfsf_sale_status;

/**
 大小分开售状态
 */
@property (nonatomic, assign) NSInteger dxf_sale_status;

/**
 胜分差开售状态
 */
@property (nonatomic, assign) NSInteger sfc_sale_status;

@property (nonatomic, assign) NSInteger sf_danguan;

@property (nonatomic, assign) NSInteger rfsf_danguan;
@property (nonatomic, assign) NSInteger dxf_danguan;
@property (nonatomic, assign) NSInteger sfc_danguan;


@property (nonatomic, strong) BBSFModel *sf;

@property (nonatomic, strong) BBRFSFModel *rfsf;

@property (nonatomic, strong) BBDXFModel *dxf;

@property (nonatomic, strong) BBSFCModel *sfc;


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


- (NSString *)getOddsWithTag:(NSString *)tag;


@end
