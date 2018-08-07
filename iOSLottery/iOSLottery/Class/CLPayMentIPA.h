//
//  CLPayMentIPA.h
//  iOSLottery
//
//  Created by 小铭 on 2016/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//  支付API

#import "CLCaiqrBusinessRequest.h"

@class CLUserPaymentInfo;

@interface CLPayMentIPA : CLCaiqrBusinessRequest

@property (nonatomic, strong) NSString *preforeToken;

- (CLUserPaymentInfo *)dealingWithRedEnvelopListFromDict:(NSDictionary *)dict;

@end
