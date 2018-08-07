//
//  BBMatchTitleView.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/4.
//  Copyright © 2017年 caiqr. All rights reserved.
//  篮球投注列表 比赛标题View

#import <UIKit/UIKit.h>

@class BBMatchModel;

@interface BBMatchTitleView : UIView

@property (nonatomic, strong) BBMatchModel *titleModel;

/**
 设置是否显示球队排名
 */
- (void)setShowRank:(BOOL)show;

- (void)setAwayTeamText:(NSString *)text;

- (void)setAwayTeamRankText:(NSString *)text;

- (void)setHostTeamText:(NSString *)text;

- (void)setHostTeamRankText:(NSString *)text;

@end
