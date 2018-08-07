//
//  CLDLTAllInfo.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLDLTAllInfo.h"
#import "CLLotteryMainBetModel.h"
#import "CLSSQConfigMessage.h"
@implementation CLDLTAllInfo

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
