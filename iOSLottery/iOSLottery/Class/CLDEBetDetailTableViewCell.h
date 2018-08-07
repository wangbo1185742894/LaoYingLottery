//
//  CLDEBetDetailTableViewCell.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/3.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLDEBetDetailTableViewCell : UITableViewCell

/**
 点击了删除按钮
 */
@property (nonatomic, copy) void(^deleteCellBlock)();

+ (instancetype)createDEBetDetailsTableViewCellWithTableView:(UITableView *)tableView;

/**
 配置数据

 @param data 数据
 */
- (void)assignBetDetailCellWithData:(id)data;

@end
