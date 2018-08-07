//
//  CQPayOrderInfo.m
//  caiqr
//
//  Created by 彩球 on 16/4/5.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CKPayOrderInfo.h"
#import "MJExtension.h"
@implementation CKPayOrderInfo

@end

@implementation CKPayToken

@end


@implementation CKRechagreInfo

+ (NSDictionary *)objectClassInArray{
    return @{
             @"pay_for_tokens" : @"CKPayToken"
             };
}

@end
