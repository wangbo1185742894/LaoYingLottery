//
//  SLAllOddsHalfOverallCell.h
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//展开全部赔率  半全场 cell

#import <UIKit/UIKit.h>
@class SLBQCModel,SLBetSelectPlayMothedInfo;
@interface SLAllOddsHalfOverallCell : UITableViewCell

@property (nonatomic, strong) SLBQCModel *bqcModel;
@property (nonatomic, strong) NSString *matchIssue;
@property (nonatomic, strong) SLBetSelectPlayMothedInfo *bqcSelectPlayMothedInfo;

+ (instancetype)createAllOddsHalfOverCellWithTableView:(UITableView *)tableView;

- (void)assignDataWithNormalData:(SLBQCModel *)bqcModel matchIssue: (NSString *)matchIssue;

@end
