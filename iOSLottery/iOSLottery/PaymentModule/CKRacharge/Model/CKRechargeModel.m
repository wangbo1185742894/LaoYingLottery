//
//  CKRechargeModel.m
//  caiqr
//
//  Created by 任鹏杰 on 2017/4/28.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKRechargeModel.h"

@implementation CKRechargeModel

+ (NSDictionary*) objectClassInArray {
    
    return @{@"channel_list":@"CKPayChannelDataSource",@"fill_list":@"CKRechargeCashModel", @"big_moneny": @"CKPayChannelDataSource",@"fill_limit_list":@"CKRechargeLimitModel"};
}

+(NSDictionary *)replacedKeyFromPropertyName{
    
    return @{@"template_value" : @"template"
             };
}

@end
