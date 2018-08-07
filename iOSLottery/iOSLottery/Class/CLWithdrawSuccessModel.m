//
//  CLWithdrawSuccessModel.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/29.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLWithdrawSuccessModel.h"

@implementation CLWithdrawSuccessModel

@end
@implementation CLUserCashWithdrawOrderModelInfo

@end
@implementation CLUserCashBalanceMemo

+ (instancetype)createUserCashBalanceMemoModelWithDic:(NSDictionary *)dic{
    
    CLUserCashBalanceMemo *memo = [[CLUserCashBalanceMemo alloc] init];
    memo.title = dic[@"title"];
    if ([dic[@"content"] isKindOfClass:[NSString class]]) {
        memo.content = dic[@"content"];
    }
    else if ([dic[@"content"] isKindOfClass:[NSArray class]])
    {
        memo.content = @"";
        memo.orderInfoArr = [NSArray arrayWithArray:dic[@"content"]];
    }
    if ([dic[@"is_default"] isEqualToString:@"1"]){
        memo.isDefault = YES;
    }else{
        memo.isDefault = NO;
    }
    return memo;
}

@end
