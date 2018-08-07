//
//  CQFreeOfPaymentViewController.h
//  caiqr
//
//  Created by 洪利 on 2017/3/9.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CLBaseViewController.h"
@class CQFreeOfPayService;
@interface CQFreeOfPaymentViewController : CLBaseViewController

+ (void)creatFreeOfPayViewControllerWithPushViewController:(UIViewController *)pushVC service:(CQFreeOfPayService*)service complete:(void (^)())resetComplete;

@end
