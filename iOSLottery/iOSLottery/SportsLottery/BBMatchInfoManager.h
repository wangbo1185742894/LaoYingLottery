//
//  BBMatchInfoManger.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//  篮球 投注信息 管理者

#import <Foundation/Foundation.h>

@class BBMatchModel,BBSeletedGameModel;

@interface BBMatchInfoManager : NSObject

+ (instancetype)shareManager;

//存储所有比赛信息（即请求回来的信息） 并且归类所有比赛数据
- (void)saveAndclassifyAllMatchsInfo:(id)data;

//获取选中的赛事数据
- (NSMutableDictionary *)getSelectMatchInfo;

//获取全部比赛信息
- (NSMutableArray *)getAllMatchArray;

/**
 获取比赛
 
 @param matchIssue matchIssue
 @return 比赛信息
 */
- (BBMatchModel *)getMatchInfoWithIssue:(NSString *)matchIssue;


/**
 获取gameId
 
 @return gameId
 */
- (NSString *)getGameId;

//返回要展示的联赛信息
- (NSArray *)getNeedShowMatchs;


/**
 存储一场比赛的选中信息
 
 @param oneGameInfo oneGameInfo
 */
- (void)saveOneMatchSelectInfo:(BBSeletedGameModel *)oneGameInfo;

/**
 存储选中的玩法
 
 @param matchIssue 场次issue
 @param playMothed 玩法
 @param selectArray 选项
 */
- (void)saveSelectBetInfoWithMatchIssue:(NSString *)matchIssue
                             palyMothed:(NSString *)playMothed
                             selectItem:(NSArray *)selectArray
                              isDanGuan:(BOOL)isDanGuan;

/**
 存储选中的玩法
 
 @param matchIssue 场次issue
 @param playMothed 玩法
 @param selectArray 选项
 @param rangFenCount 让球数
 */
- (void)saveSelectBetInfoWithMatchIssue:(NSString *)matchIssue
                             palyMothed:(NSString *)playMothed
                             selectItem:(NSArray *)selectArray
                              isDanGuan:(BOOL)isDanGuan
                           rangFenCount:(NSString *)rangFenCount;


/**
 是否可以保存投注项
 */
- (BOOL)isCanSaveSelectBetInfoWithMatchIssue:(NSString *)matchIssue;

/**
 存储选中记录的串关
 
 @param chuanGuanTag 选中的串关tag
 */
- (void)saveSelectChuanGuan:(NSString *)chuanGuanTag;

/**
 移除已储存的玩法
 
 @param matchIssue issue
 @param playMothed 玩法
 @param selectArray 选项
 */
- (void)removeSelectBetInfoWithMatchIssue:(NSString *)matchIssue
                               palyMothed:(NSString *)playMothed
                               selectItem:(NSArray *)selectArray;

/**
 移除一场比赛
 
 @param matchIssue 比赛
 */
- (void)removeOneMatchWithIssue:(NSString *)matchIssue;


/**
 移除一场比赛后 是否可以投注
 
 @param matchIssue matchIssue
 @return 是否可以投注
 */
- (BOOL)afterRemoveCanBetWithMatchIssue:(NSString *)matchIssue;

/**
 清空所有已存储的玩法
 */
- (void)clearMatch;

/**
 移除选中记录的串关
 
 @param chuanGuanTag 选中的串关tag
 */
- (void)removeSelectChuanGuan:(NSString *)chuanGuanTag;

/**
 获取对应mathcIssue的比赛选中的选项
 
 @param matchIssue match issue
 @return 单场比赛的投注信息
 */
- (BBSeletedGameModel *)getSingleMatchSelectInfoWithMatchIssue:(NSString *)matchIssue;


/**
 获取当前比赛共选多少项
 
 @param matchIssue matchIssue
 @return 项数
 */
- (NSInteger)getSingleMatchSelectPlayMothedNumberWithMatchIssue:(NSString *)matchIssue;



/**
 获取选中的比赛信息  是否有一场比赛全是单关
 
 @return hasDanGuan
 */
- (BOOL)getSelectMatchHasDanGuan;

/**
 判断所有选中的比赛是否全是单关
 
 @return 单关
 */
- (BOOL)getHasAllDanGuan;

/**
 获取选中的比赛信息 有几场比赛
 
 @return count
 */
- (NSInteger)getSelectMatchCount;

- (NSInteger)getCurrentMaxChuanGuanCount;
/**
 获取注数
 
 @return 注数
 */
- (NSInteger)getNote;


/**
 获取预计奖金
 
 @return bonus
 */
- (NSString *)getEstimateBonus;


/**
 获取倍数
 
 @return 倍数
 */
- (NSInteger)getMultiple;

- (NSInteger)getDefaultMultiple;

- (void)setMuitple:(NSInteger)number;

- (NSInteger)getMaxMultiple;

/**
 获取投注串
 
 @return 投注串
 */
+ (NSString *)getCreateOrderNumber;

/**
 获取投注串关
 
 @return 串关
 */
+ (NSString *)getCreateOrderChuanGuan;

/**
 获取可选串关数组
 
 @return array
 */
- (NSArray *)getChuanGuanArray;

- (NSInteger)getSelectChuanGuanArrayCount;

/**
 判断当前选中比赛是否是第9场的比赛 （最多选8场）
 
 @param matchIssue matchIssue
 @return bool
 */
+ (BOOL)judgeCurrentSelectIsValid:(NSString *)matchIssue;

/**
 获取当前最高串关数
 */
- (NSInteger)getCurrentMaxChuanGuanCount;

/** 获取联赛数据 */
+ (NSArray *)getNeedShowLeagueMatchs;

+ (void)updateLeagueMatchesArray:(NSArray *)leagueArr;

@end
