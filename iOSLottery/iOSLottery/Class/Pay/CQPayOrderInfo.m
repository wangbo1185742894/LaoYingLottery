//
//  CQPayOrderInfo.m
//  caiqr
//
//  Created by 彩球 on 16/4/5.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CQPayOrderInfo.h"

@implementation CQPayOrderInfo

@end

@implementation CQPayToken

@end


@implementation CQRechagreInfo

+ (NSDictionary *)objectClassInArray{
    return @{
             @"pay_for_tokens" : @"CQPayToken"
             };
}

@end