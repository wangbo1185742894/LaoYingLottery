//
//  CLAwardK3Cell.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLAwardVoModel;

@interface CLAwardK3Cell : UITableViewCell

@property (nonatomic) BOOL isShowLotteryName;

+ (CLAwardK3Cell *)createAwardK3CellWithTableView:(UITableView *)tableView;

- (void)configureKuai3Data:(CLAwardVoModel*)data;

@end
