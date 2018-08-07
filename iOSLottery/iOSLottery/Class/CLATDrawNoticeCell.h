//
//  CLATDrawNoticeCell.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//  排列3 福彩3D 排列5 开奖公告cell

#import <UIKit/UIKit.h>

@class CLAwardVoModel;

@interface CLATDrawNoticeCell : UITableViewCell

+ (instancetype)createATDrawNoticeCellWithTableView:(UITableView *)tableView;

- (void)setData:(CLAwardVoModel *)data;

- (void)setShowLotteryName:(BOOL)show;

- (void)setOnlyShowNumberText:(BOOL)show;

@end
