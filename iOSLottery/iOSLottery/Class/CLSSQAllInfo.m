//
//  CLSSQAllInfo.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/3.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLSSQAllInfo.h"
#import "CLLotteryMainBetModel.h"
#import "CLSSQConfigMessage.h"
@implementation CLSSQAllInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lastRecordPlayMothed = CLSSQPlayMothedTypeNormal;
        self.mainResquestData = [[CLLotteryMainBetModel alloc] init];
    }
    return self;
}

@end
