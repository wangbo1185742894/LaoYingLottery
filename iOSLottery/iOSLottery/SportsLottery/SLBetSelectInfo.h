//
//  SLBetSelectInfo.h
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/16.
//  Copyright © 2017年 caiqr. All rights reserved.
//  用户选中的投注项

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class SLBetSelectSingleGameInfo, SLBetSelectPlayMothedInfo;

#define SPF @"spf"
#define RQSPF @"rqspf"
#define ZJQ @"zjq"
#define BF @"bf"
#define BQC @"bqc"


@interface SLBetSelectInfo : NSObject

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

- (void)saveSelectBetInfoWithMatchIssue:(NSString *)matchIssue
                             palyMothed:(NSString *)playMothed
                             selectItem:(NSArray *)selectArray
                              isDanGuan:(BOOL)isDanGuan
                           rangQiuCount:(NSString *)rangQiuCount;

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
 投注内容
 */
@property (nonatomic, strong) NSMutableArray<SLBetSelectSingleGameInfo *> *betSelectInfo;

/**
 选择的串关选项
 */
@property (nonatomic, strong) NSMutableArray *chuanGuanArray;

/**
 投注倍数
 */
@property (nonatomic, assign) NSInteger betMultiple;


@end



//每一场比赛的选中项
@interface SLBetSelectSingleGameInfo : NSObject<NSCopying,NSMutableCopying>


/**
 标记每一场比赛
 */
@property (nonatomic, strong) NSString *matchIssue;


@property (nonatomic, strong) NSMutableArray<SLBetSelectPlayMothedInfo *> *singleBetSelectArray;


@end




//每一个玩法选中的投注项
@interface SLBetSelectPlayMothedInfo : NSObject<NSCopying,NSMutableCopying>

/**
 玩法
 */
@property (nonatomic, strong) NSString *playMothed;

/**
 当前玩法是否支持单关
 */
@property (nonatomic, assign) BOOL isDanGuan;

/**
 让球数
 */
@property (nonatomic, strong) NSString * rangQiuCount;

/**
 当前玩法选中的选项
 */
@property (nonatomic, strong) NSMutableArray *selectPlayMothedArray;

@end
