//
//  BBAllPlayMethodView.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/14.
//  Copyright © 2017年 caiqr. All rights reserved.
//  投注详情列表 全部玩法View

#import <UIKit/UIKit.h>

@class BBMatchModel;

@interface BBAllPlayMethodView : UIView

@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, strong) BBMatchModel *currentMatchInfo;

@property (nonatomic, copy) void(^reloadSelectDataBlock)(NSIndexPath *indexPath);

/**
 是否确定清除该场比赛
 */
@property (nonatomic, copy) void(^sureClearMatchBlock)();

/**
 显示视图
 */
- (void)showInWindow;

/**
 移除动画 带有动画
 */
- (void)removeFromSuperviewWithAnimation;

@end
