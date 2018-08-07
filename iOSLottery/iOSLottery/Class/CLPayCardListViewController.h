//
//  CLPayCardListViewController.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/4/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLBaseViewController.h"
#import "CKPaymentVerifyCallBackInterface.h"
@class CKLotteryPaySource;
@interface CLPayCardListViewController : CLBaseViewController<CKPaymentVerifyCallBackInterface>

@property (nonatomic, strong) CKLotteryPaySource *lotteryPaySource;
@property (nonatomic, assign) NSInteger orderType;
@property (nonatomic, strong) id payConfigure;

@end
