//
//  CKQuickBetHomeView.h
//  iOSLottery
//
//  Created by 小铭 on 2016/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//  快速支付首页

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,CLQuickHomeShowType)
{
    quickHomeRedParketsType = 0,
    quickHomePayChannelType
};

@interface CKQuickBetHomeView : UIView

@property (nonatomic, strong) NSArray *quickDataSource;

@property (nonatomic, readwrite) BOOL nextButtonStauts;
@property (nonatomic, strong) NSString *quickBetTitle;
@property (nonatomic, strong) NSString *quickConfirmTitle;
@property (nonatomic, strong) NSString *needPayAmount;
@property (nonatomic, strong) NSString *subTitle;

@property (nonatomic, readwrite) BOOL buttonStatus;

@property (nonatomic, copy) void(^selectedPaymentBlock)(id method, CLQuickHomeShowType showType);
@property (nonatomic, copy) void(^dissmissBlock)(void);
@property (nonatomic, copy) void(^nextActionBlock)(void);

- (void)reloadBetHomeView;

@end
