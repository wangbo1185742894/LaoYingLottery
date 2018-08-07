//
//  SLAllOddsScoreCell.h
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/13.
//  Copyright © 2017年 caiqr. All rights reserved.
//展开全部赔率  比分 cell

#import <UIKit/UIKit.h>
@class SLBFModel, SLBetSelectPlayMothedInfo;
@interface SLAllOddsScoreCell : UITableViewCell


@property (nonatomic, strong) NSString *matchIssue;
@property (nonatomic, strong) SLBetSelectPlayMothedInfo *scoreSelectPlayMothedInfo;
@property (nonatomic, strong) SLBFModel *bfModel;

+ (instancetype)createAllOddsScoreCellWithTableView:(UITableView *)tableView;

- (void)assignDataWithNormalData:(SLBFModel *)bfModel matchIssue: (NSString *)matchIssue;

@end
