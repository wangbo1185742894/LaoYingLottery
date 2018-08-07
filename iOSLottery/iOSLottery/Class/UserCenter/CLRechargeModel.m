//
//  CLRechargeModel.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLRechargeModel.h"

@implementation CLRechargeModel

+ (NSDictionary*) objectClassInArray {
    
    return @{@"channel_list":@"CLPaymentChannelInfo",@"fill_list":@"CLRechargeCashModel", @"big_moneny": @"CLRechargeBigMoneyModel"};
}

+(NSDictionary *)replacedKeyFromPropertyName{
    
    return @{@"template_value" : @"template"
             };
}

@end
