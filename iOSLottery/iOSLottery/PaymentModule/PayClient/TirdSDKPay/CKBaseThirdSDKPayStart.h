//
//  CKBaseThirdSDKPayStart.h
//  caiqr
//
//  Created by 洪利 on 2017/4/28.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger ,CKThirdPayMentChannelID) {
    CKThirdPayMentChannelIDPailuobei = 503,
    CKThirdPayMentChannelIDJuhezhifuAlipay = 121,
    CKThirdPayMentChannelIDJuhezhifuWechat = 504,
    CKThirdPayMentChannelIDBoingWechat = 600,
    CKThirdPayMentChannelIDBoingAlipay = 604
};



@interface CKBaseThirdSDKPayStart : NSObject





//下一个支付方式
@property (nonatomic, strong) id nextPayResponder;
@property (nonatomic, assign) CKThirdPayMentChannelID channelID;
@property (nonatomic, assign) BOOL isNeedHandleException;//是否需要处理异常
@property (nonatomic, copy) void (^ thirdPayFinished)();
//开始检测响应链
- (void)startPayWithChannel:(CKThirdPayMentChannelID)channel
                     amount:(NSNumber*)amount
             viewController:(UIViewController *)sourceViewController
               andOrderInfo:(id)orderInfo
                     canPay:(void (^)(BOOL isNeedhandleExceptions))canPay
                willPayMent:(void (^)())willPayment;
//检测到对应可以实现支付的third platform 开始最后加工数据并调用SDK发起支付
- (void)configOrderInfoThanStartPayWithOrderInfo:(id)orderInfo
                                          amount:(NSNumber*)amount
                                  viewController:(UIViewController *)sourceViewController
                                willStartPayMent:(void (^)())willStartPayment;
//支付结束回调
- (void)thirdPayFinish;


@end
