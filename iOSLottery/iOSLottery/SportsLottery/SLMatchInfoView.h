//
//  SLMatchInfoView.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//  赛事信息

#import <UIKit/UIKit.h>

@class SLMatchBetModel;

typedef void(^SLMatchInofBlock)();

@interface SLMatchInfoView : UIView

@property (nonatomic, strong) SLMatchBetModel *infoModel;

@property (nonatomic, copy) SLMatchInofBlock isShowStory;

/**
 点击了历史战绩
 */
- (void)returnShowHistoryClick:(SLMatchInofBlock)block;

@end
