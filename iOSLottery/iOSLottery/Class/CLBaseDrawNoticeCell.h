//
//  CLBaseDrawNoticeCell.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/20.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLAwardVoModel;

@interface CLBaseDrawNoticeCell : UITableViewCell


@property (nonatomic, strong) UIView* bottomLine;

+ (instancetype)createDrawNoticeCellWithTableView:(UITableView *)tableView;

- (void)setData:(CLAwardVoModel *)data;

- (void)setShowLotteryName:(BOOL)show;

- (void)setOnlyShowNumberText:(BOOL)show;

@end
