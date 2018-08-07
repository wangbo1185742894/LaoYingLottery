//
//  CKThirdPayJuhezhifuStart.m
//  caiqr
//
//  Created by 洪利 on 2017/4/28.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKThirdPayJuhezhifuStart.h"
#import "SPayClient.h"
#import "CKThirdPayConfig.h"
#import "CKThirdPayJuhezhifuAlipay.h"
@implementation CKThirdPayJuhezhifuStart

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isNeedHandleException = YES;
        self.channelID = CKThirdPayMentChannelIDJuhezhifuWechat;
        self.nextPayResponder = [[CKThirdPayJuhezhifuAlipay alloc] init];
    }
    return self;
}





- (void)configOrderInfoThanStartPayWithOrderInfo:(id)orderInfo amount:(NSNumber *)amount viewController:(UIViewController *)sourceViewController willStartPayMent:(void (^)())willStartPayment{
    [CKThirdPayConfig resetUrlSchemesWithString:juheScheme];
    
    
    NSString* token = [orderInfo objectForKey:@"token_id"];
    NSString* services = [orderInfo objectForKey:@"services"];
    NSString* scan_code = [orderInfo objectForKey:@"scan_code"];
    !willStartPayment?:willStartPayment();
    //调起SPaySDK支付
    [[SPayClient sharedInstance] pay:sourceViewController
                              amount:amount
                   spayTokenIDString:token
                   payServicesString:services
                              finish:^(SPayClientPayStateModel *payStateModel,
                                       SPayClientPaySuccessDetailModel *paySuccessDetailModel) {
//                                  
//                                  //更新订单号
//                                  weakSelf.out_trade_noText.text = [NSString spay_out_trade_no];
//                                  
//                                  
                                  if (payStateModel.payState == SPayClientConstEnumPaySuccess) {
                                      
                                      //支付成功回调
                                      [self thirdPayFinish];
                                      NSLog(@"支付成功");
                                      NSLog(@"支付订单详情-->>\n%@",[paySuccessDetailModel description]);
                                  }else{
                                      NSLog(@"支付失败，错误号:%d",payStateModel.payState);
                                  }
                                  
                              }];
    
    NSLog(@"支付信息 %@", orderInfo);
    NSLog(@"我是聚合支付");
}






@end
