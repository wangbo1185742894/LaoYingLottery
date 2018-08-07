//
//  CQtempClass.h
//  caiqr
//
//  Created by 洪利 on 2017/4/28.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CKtempClass : NSObject

@property (nonatomic, copy)  void (^thirdPayFinished)();


/**
 发起第三方支付

 @param payChannel channel
 @param amount 支付金额
 @param orderInfo 支付信息
 @param sourceViewController viewController
 @param isneedhandleexception 是否需要处理异常
 @param finished 支付结束
 @param willStartPayment 即将开始支付
 */
- (void)startPay:(NSInteger)payChannel
          anoumt:(NSNumber *)amount
    andOrderInfo:(id)orderInfo
  viewController:(UIViewController *)sourceViewController
isNeedHandleException:(void (^)(BOOL isNeedHandleException))isneedhandleexception
       payFinish:(void (^)())finished
willStartPayMent:(void (^)())willStartPayment;



@end
