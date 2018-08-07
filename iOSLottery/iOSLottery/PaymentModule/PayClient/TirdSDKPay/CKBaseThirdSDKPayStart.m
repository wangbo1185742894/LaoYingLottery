//
//  CKBaseThirdSDKPayStart.m
//  caiqr
//
//  Created by 洪利 on 2017/4/28.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKBaseThirdSDKPayStart.h"

@implementation CKBaseThirdSDKPayStart


//检测响应链
- (void)startPayWithChannel:(CKThirdPayMentChannelID)channel
                     amount:(NSNumber*)amount
             viewController:(UIViewController *)sourceViewController
               andOrderInfo:(id)orderInfo canPay:(void (^)(BOOL))canPay
                willPayMent:(void (^)())willPayment{
    if (channel == self.channelID) {
        !canPay?:canPay(self.isNeedHandleException);
        //本类处理
        //fix  Issue #3
        if (![self dictionaryWithJsonString:orderInfo?:nil]) return;
        [self configOrderInfoThanStartPayWithOrderInfo:[self dictionaryWithJsonString:orderInfo?:nil]
                                                amount:amount
                                        viewController:sourceViewController
                                      willStartPayMent:willPayment];
    }else{
        if (self.nextPayResponder) {
            //存在下一个可能响应的支付方式
            [self.nextPayResponder setThirdPayFinished:self.thirdPayFinished];
            [self.nextPayResponder startPayWithChannel:channel
                                                amount:amount
                                        viewController:sourceViewController
                                          andOrderInfo:orderInfo
                                                canPay:canPay
                                           willPayMent:willPayment];
        }else{
        
            //没有下一个可能响应的支付方式了
            NSLog(@"响应链上所有的支付方式都无法处理此方式支付，即刻回调");
        }
    }

}

//解析
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    //fix  Issue #3
    return dic?:nil;
    
}


//开始支付
- (void)configOrderInfoThanStartPayWithOrderInfo:(id)orderInfo amount:(NSNumber *)amount viewController:(UIViewController *)sourceViewController willStartPayMent:(void (^)())willStartPayment{

}

//支付结束
- (void)thirdPayFinish{
    if (self.thirdPayFinished) {
        self.thirdPayFinished();
    }
}




@end
