//
//  CLSSQAwardNoticeCell.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/8.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLSSQAwardNoticeView.h"

@class CLAwardVoModel;
@interface CLSSQAwardNoticeCell : UITableViewCell

@property (nonatomic) BOOL isShowLotteryName;

+ (instancetype)createSSQAwardNoticeCellWithTableView:(UITableView *)tableView;

- (void)configureSQQData:(CLAwardVoModel*)data type:(CLAwardLotteryType)type;

- (void)setOnlyShowNumberText:(BOOL)show;

@end
