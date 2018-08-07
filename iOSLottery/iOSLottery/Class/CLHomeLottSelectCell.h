//
//  CLHomeLottSelectCell.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/7.
//  Copyright © 2016年 caiqr. All rights reserved.
//  首页彩种入口 自定义View

#import <UIKit/UIKit.h>
@class CLHomeGameEnteranceModel;

@protocol CLHomeLottSelectCellDelegate <NSObject>

- (void)selectCellLott:(CLHomeGameEnteranceModel*)lott index:(NSIndexPath *)index;

@end

@interface CLHomeLottSelectCell : UITableViewCell

+ (CLHomeLottSelectCell*) lottSelectCellInitWith:(UITableView*)tableView;

@property (nonatomic, weak) id <CLHomeLottSelectCellDelegate> delegate;

/**
 设置cell数据
 */
- (void)configureLottery:(NSArray*)lotterys;

@end
