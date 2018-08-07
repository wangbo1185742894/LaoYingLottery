//
//  CLFollowDetailHeaderView.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLFollowDetailHeaderViewModel;

@interface CLFollowDetailHeaderView : UIView

- (void)configureHeaderViewModel:(CLFollowDetailHeaderViewModel*)viewModel;

@property (nonatomic, assign) NSInteger currentSaleTime;

@property (nonatomic, copy) void(^gotoPayment)(void);

@end
