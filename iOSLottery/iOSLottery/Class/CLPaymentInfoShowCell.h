//
//  CLPaymentInfoShowCell.h
//  iOSLottery
//
//  Created by 小铭 on 2016/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//  正常支付页面显示需支付金额或是点击切换切换红包Cell

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CLPaymentInfoShowCellStyle)
{
    defaultPaymentShowStyle = 0,                    //** 默认样式 */
    noIconAndNoSelectedButtonDepositStyle,       //** 红包支付可点击 没有选中按钮样式 */
};
@interface CLPaymentInfoShowCell : UITableViewCell
//** 配置样式为添加银行卡 */
@property (nonatomic, assign) CLPaymentInfoShowCellStyle cellShowStyle;

- (void)assignUserCashDepositCellWithObj:(id)obj;

@end
