//
//  CLQuickBetRedParketsView.h
//  iOSLottery
//
//  Created by 小铭 on 2016/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//  快速支付选择红包View

#import <UIKit/UIKit.h>

@interface CLQuickBetRedParketsView : UIView

@property (nonatomic, copy) void(^selectedRedParketsBlock)(id redModel,BOOL noselected);

@property (nonatomic, copy) void(^redParketsBackBlock)(void);

- (void)assignQuickBetpaymentViewWithMethod:(NSArray *)paymentArr;

@end
