//
//  CLUserCenterRequest.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/12.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLUserCenterRequest.h"

@implementation CLUserCenterRequest


- (NSDictionary *)requestBaseParams{
    
    return @{@"cmd" : @"get_account_and_red_balance"};
}

@end
