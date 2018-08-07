//
//  CLQuickBetPaySelectedView.h
//  iOSLottery
//
//  Created by 小铭 on 2016/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//  快速支付选择支付方式View
#import <UIKit/UIKit.h>

@interface CLQuickBetPaySelectedView : UIView

@property (nonatomic, copy) void (^selectedPaymentBlock)(id payInfo);

@property (nonatomic, copy) void (^paymentBackBlock)(void);

- (void)updataPaymentWithData:(NSArray *)dataArr;

@end
