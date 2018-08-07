//
//  SLBetDetailsModel.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/18.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLBetDetailsModel.h"

@implementation SLBetDetailsModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.itemArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

@end

@implementation SLBetDetailsItemModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.betArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

@end
