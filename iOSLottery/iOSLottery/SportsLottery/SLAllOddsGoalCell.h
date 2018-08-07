//
//  SLAllOddsGoalCell.h
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//  展开全部赔率  总进球 cell

#import <UIKit/UIKit.h>
@class SLJPSModel, SLBetSelectPlayMothedInfo;
@interface SLAllOddsGoalCell : UITableViewCell

@property (nonatomic, strong) SLJPSModel *jqsModel;

@property (nonatomic, strong) NSString *matchIssue;
@property (nonatomic, strong) SLBetSelectPlayMothedInfo *jqsSelectPlayMothedInfo;


+ (instancetype)createAllOddsGoalCellWithTableView:(UITableView *)tableView;

- (void)assignDataWithNormalData:(SLJPSModel *)jqsModel matchIssue: (NSString *)matchIssue;


@end
