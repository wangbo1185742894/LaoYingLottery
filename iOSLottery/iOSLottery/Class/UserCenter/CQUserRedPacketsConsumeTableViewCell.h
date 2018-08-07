//
//  CQUserRedPacketsConsumeTableViewCell.h
//  caiqr
//
//  Created by 小铭 on 16/4/18.
//  Copyright © 2016年 Paul. All rights reserved.
//  用户红包消费详情记录

#import <UIKit/UIKit.h>

@interface CQUserRedPacketsConsumeTableViewCell : UITableViewCell

+ (instancetype)userRedPacketConsumeTableView:(UITableView *)tableView
                                       Method:(id)obj
                                   clickOrder:(void(^)(NSString *orderIDSring))clickOrderDetailBlock;

@end


//** 用户红包消费详情HeaderView */
@interface CQUserRedPacketsConsumeTableViewHeaderView : UIView

+ (instancetype)userRedPacketsConsumeTableViewHeaderViewWithMethod:(id)obj;

@end


