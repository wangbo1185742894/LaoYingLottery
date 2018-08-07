//
//  SLAllOddsUnsaleCell.h
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/25.
//  Copyright © 2017年 caiqr. All rights reserved.
// 全部赔率列表 的 未开售 cell

#import <UIKit/UIKit.h>

@interface SLAllOddsUnsaleCell : UITableViewCell

@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, assign) BOOL isDanGuan;

+ (instancetype)createAllOddsUnsaleCellWithTableView:(UITableView *)tableView;

@end
