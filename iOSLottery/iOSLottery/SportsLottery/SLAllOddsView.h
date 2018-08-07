//
//  SLAllOddsView.h
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/13.
//  Copyright © 2017年 caiqr. All rights reserved.
//展开全部赔率View

#import <UIKit/UIKit.h>
@class SLMatchBetModel;
@class SLBetSelectSingleGameInfo;
@interface SLAllOddsView : UIView

@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, strong) SLMatchBetModel *currentMatchInfo;
@property (nonatomic, copy) void(^reloadSelectDataBlock)(NSIndexPath *indexPath);

/**
 是否确定清除该场比赛
 */
@property (nonatomic, copy) void(^sureClearMatchBlock)();

- (void)saveMatchSelect;

/**
 显示视图
 */
- (void)showInWindow;

/**
 移除动画 带有动画
 */
- (void)removeFromSuperviewWithAnimation;

@end
