//
//  CLHomeQuickBetNewCell.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/4/20.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLHomeQuickBetCell.h"

@class CLHomeHotBetModel;

@interface CLHomeQuickBetNewCell : UITableViewCell

@property (nonatomic, strong) CLHomeHotBetModel* hotBetModel;

@property (nonatomic, assign) BOOL isShowBottomLine;

@property (nonatomic, weak) id<CLHomeQuickBetCellDelegate> delegate;

+ (instancetype)homeQuickBetNewCellCreateWithTableView:(UITableView *)tableView;

@end
