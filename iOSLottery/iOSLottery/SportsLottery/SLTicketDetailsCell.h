//
//  CLTicketDetailsCell.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/4/22.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLTicketDetailsItemModel;

@interface SLTicketDetailsCell : UITableViewCell

/**
 数据模型
 */
@property (nonatomic, strong) SLTicketDetailsItemModel *ticketModel;

+ (instancetype)createTicketDetailsCellWithTableView:(UITableView *)tableView;

@end
