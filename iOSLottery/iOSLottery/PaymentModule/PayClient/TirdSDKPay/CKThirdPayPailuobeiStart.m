//
//  CKThirdPayPailuobeiStart.m
//  caiqr
//
//  Created by 洪利 on 2017/4/28.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKThirdPayPailuobeiStart.h"
#import "CKThirdPayJuhezhifuStart.h"
#import "CKPayClient.h"
@implementation CKThirdPayPailuobeiStart

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isNeedHandleException = NO;
        self.channelID = CKThirdPayMentChannelIDPailuobei;
        self.nextPayResponder = [[CKThirdPayJuhezhifuStart alloc] init];
    }
    return self;
}



- (void)configOrderInfoThanStartPayWithOrderInfo:(id)orderInfo amount:(NSNumber *)amount viewController:(UIViewController *)sourceViewController willStartPayMent:(void (^)())willStartPayment{
    NSDictionary *wxParameter = orderInfo[@"pay_info"]?:nil;
    if (!wxParameter || wxParameter.count == 0 || !wxParameter[@"appid"]) {
        /** 支付异常 */
        [[CKPayClient sharedManager].intermediary showError:@"支付异常"];
        return;
    }
    /** 注册APP */
    NSString *appID = [NSString stringWithFormat:@"%@",wxParameter[@"appid"]];
    [WXApi registerApp:appID];
    
    if (![WXApi isWXAppInstalled]) {
        /** 没有安装微信 */
        [[CKPayClient sharedManager].intermediary showError:@"请安装微信客户端"];
        [self thirdPayFinish];
        return;
    }
    !willStartPayment?:willStartPayment();
    /** 唤起API */
//    PayReq* req = [[PayReq alloc] init];
//    req.partnerId = [wxParameter objectForKey:@"partnerid"];
//    req.prepayId = [wxParameter objectForKey:@"prepayid"];
//    req.nonceStr = [wxParameter objectForKey:@"noncestr"];
//    req.timeStamp = (UInt32)[[NSString stringWithFormat:@"%@",[wxParameter objectForKey:@"timestamp"]] intValue];
//    req.package = [wxParameter objectForKey:@"package"];
//    req.sign = [wxParameter objectForKey:@"sign"];
//    [WXApi sendReq:req];
    NSLog(@"我是派洛贝");
}

/** 微信SDK 回调 */
- (void)onResp:(BaseResp *)resp {
    [self thirdPayFinish];
}

@end
