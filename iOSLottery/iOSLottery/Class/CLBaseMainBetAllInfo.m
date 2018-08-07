//
//  CLBaseMainBetAllInfo.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/22.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseMainBetAllInfo.h"
#import "CLLotteryMainBetModel.h"
@implementation CLBaseMainBetAllInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lastRecordPlayMothed = 0;
        self.mainResquestData = [[CLLotteryMainBetModel alloc] init];
        
        _omission = YES;
    }
    return self;
}

@end
