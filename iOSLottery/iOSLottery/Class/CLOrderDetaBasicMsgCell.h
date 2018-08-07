//
//  CLOrderDetaBasicMsgCell.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/15.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLOrderDetailLineViewModel;

@interface CLOrderDetaBasicMsgCell : UITableViewCell

@property (nonatomic, strong) UITableView *GestureTableView;

/** 长按复制 */
@property (nonatomic, copy) void (^contentLongBlock)(CGRect contentCellRect,UILabel *contentLabel);

- (void)setUpBasicMsg:(CLOrderDetailLineViewModel*)viewModel;

@property (nonatomic, copy) void(^cellContentClick)(CLOrderDetailLineViewModel *model);

@end
