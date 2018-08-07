//
//  CLSFCDetailsCell.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/27.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLSFCBetModel;

@interface CLSFCDetailsCell : UITableViewCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView;

- (void)setData:(CLSFCBetModel *)data;

@end
