//
//  CLLotteryBetRequest.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/17.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLLotteryBetRequest.h"

@implementation CLLotteryBetRequest

- (instancetype) init {
    
    self = [super init];
    if (self ) {
        
    }
    return self;
}
- (NSTimeInterval)requestTimeoutInterval {
    
    return 7.f;
}

- (NSString *)requestBaseUrlSuffix {
    
    return [NSString stringWithFormat:@"/bet/%@",self.gameEn];
}


@end
