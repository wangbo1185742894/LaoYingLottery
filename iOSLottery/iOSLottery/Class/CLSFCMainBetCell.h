//
//  CLSFCMainBetCell.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/24.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLSFCBetModel;

@interface CLSFCMainBetCell : UITableViewCell

@property (nonatomic, copy) void(^showHistoryBlock)(CLSFCMainBetCell *);

+ (instancetype)createCellWithTableView:(UITableView *)tableView;

- (void)setData:(CLSFCBetModel *)data;

@end
