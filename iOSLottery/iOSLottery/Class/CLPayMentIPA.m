//
//  CLPayMentIPA.m
//  iOSLottery
//
//  Created by 小铭 on 2016/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLPayMentIPA.h"
#import "CLAPI.h"
#import "CLAppContext.h"
#import "CLUserPaymentInfo.h"
#import "CLAccountInfoModel.h"
#import "CLQuickRedPacketsModel.h"
#import "CLUserPayAccountInfo.h"


@interface CLPayMentIPA() <CLBaseConfigRequest>

@property (nonatomic, assign) long long userBalance;

@end

@implementation CLPayMentIPA

- (NSString *)methodName {
    return @"orderPayInfoWithPreToken";
}

- (NSDictionary *)requestBaseParams {
    return @{@"cmd":@"get_pay_for_list_has_pre_token_cash",
             @"pre_handle_token":self.preforeToken,
             @"new_client":@"1",
             @"pay_version":[CLAppContext payVersion]};
}

- (CLUserPaymentInfo *)dealingWithRedEnvelopListFromDict:(NSDictionary *)dict
{
    return [CLUserPaymentInfo mj_objectWithKeyValues:dict];
}

@end

