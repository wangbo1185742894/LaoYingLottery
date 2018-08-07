//
//  CLPaymentSelectedRedCell.h
//  iOSLottery
//
//  Created by 小铭 on 2016/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//  正常支付选择红包选择cell

#import <UIKit/UIKit.h>
@class CLQuickRedPacketsModel;
@interface CLPaymentSelectedRedCell : UITableViewCell

- (void)assignPaymentSelectedUserRedPacketsListCellWithObj:(CLQuickRedPacketsModel *)model;

@end
