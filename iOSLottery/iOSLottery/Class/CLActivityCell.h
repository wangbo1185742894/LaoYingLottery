//
//  CLActivityCell.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/4/5.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLActivityModel;

@interface CLActivityCell : UITableViewCell

/**
 数据模型
 */
@property (nonatomic, strong) CLActivityModel *model;

+ (CLActivityCell *)activityCellCreateWithTableView:(UITableView *)tableView;

@end
