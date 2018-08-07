//
//  CLHomeQuickBetCell.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/7.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLHomeHotBetModel;

@protocol CLHomeQuickBetCellDelegate <NSObject>

- (void)createOrderSuccess:(id)data payAccount:(NSInteger)payAccount;
- (void)createOrderFail:(id)data;
- (void) timeOut;   //倒计时结束
- (void)refreshData;

@end

@interface CLHomeQuickBetCell : UITableViewCell

@property (nonatomic, assign) BOOL isShowBottomLine;

@property (nonatomic, strong) CLHomeHotBetModel* hotBetModel;

@property (nonatomic, weak) id<CLHomeQuickBetCellDelegate> delegate;

+ (instancetype)homeQuickBetCellCreateWithTableView:(UITableView *)tableView;

@end
