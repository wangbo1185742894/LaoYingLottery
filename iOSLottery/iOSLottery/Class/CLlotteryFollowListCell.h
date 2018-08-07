//
//  CLlotteryFollowListCell.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/6/1.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLFollowListModel;

@interface CLlotteryFollowListCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLable;      //彩种类型
@property (nonatomic, strong) UILabel *timerLabel;      //彩种时间
@property (nonatomic, strong) UILabel *contentLable;    //订单状态
@property (nonatomic, strong) UILabel *cashLable;       //订单金额

@property (nonatomic, strong) CLFollowListModel *listModel;

+ (instancetype)createLotteryFollowListCellWith:(UITableView *)tableView;

@end
