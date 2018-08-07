//
//  CLDERecentAwardTableViewCell.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/30.
//  Copyright © 2016年 caiqr. All rights reserved.
//
//D11 近期开奖列表 cell
#import <UIKit/UIKit.h>

@interface CLDERecentAwardTableViewCell : UITableViewCell

@property (nonatomic, assign) NSInteger signCount;
/**
 创建cell

 @param tableView    tableView
 @param isBackGround 是否有背景

 @return 返回cell
 */
+ (CLDERecentAwardTableViewCell *)createRecentAwardTableViewCell:(UITableView __weak*)tableView isBackground:(BOOL)isBackGround data:(id)data;

@end
