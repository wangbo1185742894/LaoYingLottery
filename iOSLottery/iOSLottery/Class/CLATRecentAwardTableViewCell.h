//
//  CLATRecentAwardTableViewCell.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/13.
//  Copyright © 2017年 caiqr. All rights reserved.
//  排列3 排列5 福彩3D 近期开奖Cell

#import <UIKit/UIKit.h>

@interface CLATRecentAwardTableViewCell : UITableViewCell

+ (instancetype)createRecentAwardTableViewCell:(UITableView __weak*)tableView isBackground:(BOOL)isBackGround data:(id)data;

@end
