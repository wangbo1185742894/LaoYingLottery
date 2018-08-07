//
//  CQCustomRequest.m
//  caiqr
//
//  Created by 洪利 on 2017/3/16.
//  Copyright © 2017年 Paul. All rights reserved.
//


#import "CQCustomRequestAPI.h"
#import "CLAppContext.h"
@implementation CQCustomRequestAPI

- (NSTimeInterval)requestTimeoutInterval{
    
    return 2.f;
}

- (NSDictionary *)requestBaseParams{
    
    return @{@"cmd":@"small_secret_remind",@"token": [[CLAppContext context] token]};
}

@end
