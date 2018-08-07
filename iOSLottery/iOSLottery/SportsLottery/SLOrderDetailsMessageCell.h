//
//  SLOrderDetailsMessageCell.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/6/29.
//  Copyright © 2017年 caiqr. All rights reserved.
//  订单详情 订单信息cell

#import <UIKit/UIKit.h>

@class SLBODOrderMessageModel;

@interface SLOrderDetailsMessageCell : UITableViewCell

@property (nonatomic, strong) SLBODOrderMessageModel *messageModel;

@property (nonatomic, copy) void(^messageCellBlock)();

/** 长按复制 */
@property (nonatomic, copy) void (^contentLongBlock)(CGRect contentCellRect,UILabel *contentLabel);

+ (instancetype)createOrderDetailsMessageCellWithTableView:(UITableView *)tableView;

@end
