//
//  SLMatchSectionHeaderView.h
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/12.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLMatchBetGroupModel;

@interface SLMatchSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) void(^clickSectionHeadviewBlock)(SLMatchSectionHeaderView *);

@property (nonatomic, strong) SLMatchBetGroupModel *headerModel;

+ (SLMatchSectionHeaderView *)createMatchSecionHeaderViewWithTableView:(UITableView *)tableView;

@end
