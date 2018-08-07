//
//  CLOrdDetaHeaderView.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLOrderDetailHeaderViewModel;

@interface CLOrdDetaHeaderView : UIView

- (void) setUpHeaderViewModel:(CLOrderDetailHeaderViewModel*)viewModel;

@property (nonatomic, strong) NSString *currentPeriod;
@property (nonatomic, assign) NSInteger saleTime;

@property (nonatomic, copy) void(^detaHeadPayment)(void);

@end
