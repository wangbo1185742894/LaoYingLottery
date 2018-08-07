//
//  CQRedPacketsTableViewCell.h
//  caiqr
//
//  Created by huangyuchen on 16/8/31.
//  Copyright © 2016年 Paul. All rights reserved.
//3.8版  红包列表cell

#import <UIKit/UIKit.h>

@interface CQRedPacketsTableViewCell : UITableViewCell

+ (instancetype)createRedPacketsCellWithInitiator:(UITableView *)tableView
                                           cellId:(NSString *)cellId
                                             data:(id)data;

@property (nonatomic, copy) void(^redPacketsUseBlock)();

@end
