//
//  CLWithdrawCashCell.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/12.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLWithdrawAccountInfo;

@protocol CLWithdrawCashCellDelegate <NSObject>

- (void) userInputWithdrawCash:(NSString*)money;

@end

@interface CLWithdrawCashCell : UITableViewCell

+ (CGFloat) cellHeight;

@property (nonatomic, strong) UILabel* withdrawTitleLbl;
@property (nonatomic, strong) UILabel* withdrawCashLbl;
@property (nonatomic, weak) id <CLWithdrawCashCellDelegate> delegate;
@property (nonatomic) long long availWithdrawCash;

@end
