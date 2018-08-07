//
//  UIButton+SMSCertify.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/5.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMSCertifyDelegate <NSObject>

- (void) startTimeCountDown;
- (void) endTimeCountDown;

- (BOOL) canStarting;


@end

@interface UIButton (SMSCertify)

@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, assign) NSTimeInterval timerCountDownCurrentSec;
@property (nonatomic, weak) id<SMSCertifyDelegate> smsDelegate;

- (void) addCertifyDelegate:(id<SMSCertifyDelegate>) delegate;

- (void)gettingCertifyCode;

@end
