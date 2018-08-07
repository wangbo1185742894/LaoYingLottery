//
//  CLAwardD11Cell.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLAwardVoModel;

@interface CLAwardD11Cell : UITableViewCell

@property (nonatomic) BOOL isShowLotteryName;

+ (CLAwardD11Cell *)createAwardD11CellWithTableView:(UITableView *)tableView;

- (void)configureD11Data:(CLAwardVoModel*)data;

@end
