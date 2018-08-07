//
//  CLPersonalMsgCell.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/22.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLPersonalMsgViewModel;

@interface CLPersonalMsgCell : UITableViewCell

@property (nonatomic, assign) BOOL has_BottomLine;//是否有底部分割线

+ (CLPersonalMsgCell*)getPersonalMsgCellWithTableView:(UITableView __weak *)tableView;

- (void)configurePersonalMessage:(CLPersonalMsgViewModel*)viewModel;


@end
