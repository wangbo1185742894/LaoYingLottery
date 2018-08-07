//
//  SLFootballMatchView.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/11.
//  Copyright © 2017年 caiqr. All rights reserved.
//  投注列表 足球投注view

#import <UIKit/UIKit.h>

@class SLMatchBetModel, SLBetSelectSingleGameInfo;

@interface SLFootballMatchView : UIView

@property (nonatomic, assign) BOOL leftLineShow;

@property (nonatomic, assign) BOOL topLineShow;

@property (nonatomic, assign) BOOL rightLineShow;

@property (nonatomic, assign) BOOL bottomLineShow;

@property (nonatomic, strong) SLMatchBetModel *playModel;

@property (nonatomic, strong) SLBetSelectSingleGameInfo *selectedInfo;

@property (nonatomic, copy) void(^reloadSelectNumberBlock)();
@end
