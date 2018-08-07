//
//  CLWithdrawFollowCell.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/13.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLWithdrawFollowModel;

@interface CLWithdrawFollowCell : UITableViewCell

+ (CGFloat) cellHeight;

- (void)configureWithFollow:(CLWithdrawFollowModel*)follow;

@end
