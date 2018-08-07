//
//  CKFOPAlertViewController.h
//  caiqr
//
//  Created by 洪利 on 2017/4/27.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CKFOPService;
@interface CKFOPAlertViewController : UIViewController

+ (void)creatFreeOfPayViewControllerWithPushViewController:(UIViewController *)pushVC service:(CKFOPService*)service complete:(void (^)(id))resetComplete;

@end
