//
//  CLOrderDetailModel.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLOrderDetailModel.h"

@implementation CLOrderDetailListViewModel

- (instancetype) init {
    
    self = [super init];
    if (self) {
        self.dataArrays = [NSMutableArray new];
    }
    return self;
}

@end


@implementation CLOrderDetailModel

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.orderDetailData = [NSMutableArray new];
    }
    return self;
}

@end


@implementation CLOrderDetailBasicModel

@end
