//
//  CLQuickPaySelectedCell.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/26.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CLQuickPaymentShowStyle)
{
    /** 默认样式 */
    CLQuickPaymentDefaultStyle = 0,
    /** 账户余额不足样式 */
    CLQuickPaymentNotSelectedStyle
};

@interface CLQuickPaySelectedCell : UITableViewCell

@property (nonatomic, assign) CLQuickPaymentShowStyle showStyle;

+ (CGFloat)quickBetPaySelectedTableViewCellHeight;

- (void)assignQuickBetCellWithMethod:(id)method;

@end
