//
//  CLLotteryOrderListCell.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/11.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLLotteryOrderListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;//图标
@property (nonatomic, strong) UILabel* titleLable;      //彩种类型
@property (nonatomic, strong) UILabel *timerLabel;      //彩种时间
@property (nonatomic, strong) UILabel* contentLable;    //订单状态
@property (nonatomic, strong) UILabel* cashLable;       //订单金额

+ (instancetype)createLotteryOrderListCell:(UITableView *)tableView;

@end
