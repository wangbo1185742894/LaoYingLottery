//
//  SLMatchBetCell.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/11.
//  Copyright © 2017年 caiqr. All rights reserved.
//  投注列表cell

#import <UIKit/UIKit.h>
#import "SLMatchHistoryView.h"

@class SLMatchBetModel, SLBetSelectSingleGameInfo;

@interface SLMatchBetCell : UITableViewCell

@property (nonatomic, strong) SLMatchBetModel *matchBetModel;

@property (nonatomic, strong) SLBetSelectSingleGameInfo *selectInfoModel;


+ (SLMatchBetCell *)createBetCellWithTableView:(UITableView *)tableView;


/**
 选择了多少项玩法
 */
- (void)selectPlayMothedItemNumber;
/**
 需要刷新tableView
 */
@property (nonatomic, copy) void(^reloadSelectMatchBlock)(SLMatchBetCell *);

@property (nonatomic, copy) void(^showHistoryBlock)(SLMatchBetCell *);
/**
 点击了展开全部赔率
 */
@property (nonatomic, copy) void(^unfoldAllOddsBlock)();


/**
 点击了历史战绩
 */
@property (nonatomic, copy) void(^historyOnClickBlock)(NSString *url);



@end
