//
//  CQUsePaymentPwdViewController.h
//  caiqr
//
//  Created by 彩球 on 16/4/7.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CLBaseViewController.h"

@interface CQUsePaymentPwdViewController : CLBaseViewController

- (instancetype) initWithCommonParam:(id)params;

@property (nonatomic, copy) void(^passwordCheckSuccess)(void);

@end
