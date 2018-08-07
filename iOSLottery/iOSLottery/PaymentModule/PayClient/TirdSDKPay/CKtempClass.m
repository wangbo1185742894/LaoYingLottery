//
//  CQtempClass.m
//  caiqr
//
//  Created by 洪利 on 2017/4/28.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKtempClass.h"
#import "CKThirdPayPailuobeiStart.h"
@interface CKtempClass ()
@property (nonatomic, strong) CKThirdPayPailuobeiStart *pailuobei;

@end
@implementation CKtempClass


/****
 
 支付渠道流程
    ↓
 派洛贝
    ↓
 聚合支付（微信）
    ↓
 聚合支付（支付宝）
    ↓
 招商 （支付宝）
    ↓
 招商 （微信）
 
 
 
 
 
 ****/



- (void)startPay:(NSInteger)payChannel
          anoumt:(NSNumber *)amount
    andOrderInfo:(id)orderInfo
  viewController:(UIViewController *)sourceViewController
isNeedHandleException:(void (^)(BOOL isNeedHandleException))isneedhandleexception
       payFinish:(void (^)())finished
willStartPayMent:(void (^)())willStartPayment{
    self.pailuobei = [[CKThirdPayPailuobeiStart alloc] init];
    self.thirdPayFinished = finished;
    self.pailuobei.thirdPayFinished = self.thirdPayFinished;
    [self.pailuobei startPayWithChannel:payChannel
                                 amount:amount
                         viewController:sourceViewController
                           andOrderInfo:orderInfo
                                 canPay:isneedhandleexception
                            willPayMent:willStartPayment];
}


@end
