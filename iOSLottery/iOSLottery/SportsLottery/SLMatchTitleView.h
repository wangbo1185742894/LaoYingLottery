//
//  SLMatchTitleView.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/11.
//  Copyright © 2017年 caiqr. All rights reserved.
//  比赛显示比赛双方队名的view

#import <UIKit/UIKit.h>

@class SLMatchBetModel;

@interface SLMatchTitleView : UIView

@property (nonatomic, strong) SLMatchBetModel *titleModel;

/**
 设置左侧 右侧 球队名 (不能设置飘红状态)
 */
- (void)setleftTeamName:(NSString *)leftName rightTeamName:(NSString *)rigthName;

@end
