//
//  CLRechargeCashView.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/15.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CLRechargeCashViewDelegate <NSObject>

@optional
- (void)rechargeCashChange:(NSInteger)cash;

- (void)vipService;

@end

@interface CLRechargeCashView : UIView

@property (nonatomic, weak) id <CLRechargeCashViewDelegate> delegate;

- (void) configureFillList:(NSArray*)fillList bigMoney:(NSArray *)bigMoney template:(NSString *)templateValue;

- (void) inputCashContentLimit:(BOOL) isLimit;

- (long long) getRechargeMoney;

@end
