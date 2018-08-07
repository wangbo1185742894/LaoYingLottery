//
//  CLSFCOrderDetailsCell.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/30.
//  Copyright © 2017年 caiqr. All rights reserved.
//  sfc玩法 赛事赛果cell

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CLSFCMatchResultType){

    CLSFCMatchResultOrderType,
    CLSFCMatchResultPeriodType
};

@class CLOrderDetailBetNumModel;

@interface CLSFCMatchResultCell : UITableViewCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView type:(CLSFCMatchResultType)type;

- (void)setModel:(CLOrderDetailBetNumModel *)model;

@end
