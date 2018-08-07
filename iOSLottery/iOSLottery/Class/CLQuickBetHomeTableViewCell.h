//
//  CLQuickBetHomeTableViewCell.h
//  iOSLottery
//
//  Created by 小铭 on 2016/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//  快速支付首页Cell

#import <UIKit/UIKit.h>

@interface CLQuickBetHomeTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *itemString;
@property (nonatomic, strong) NSString *iconString;

+ (CGFloat)quickBetHomeTableViewCellHeight;

@end
