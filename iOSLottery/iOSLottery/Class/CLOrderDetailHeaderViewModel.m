//
//  CLOrderDetailHeaderViewModel.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/17.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLOrderDetailHeaderViewModel.h"

@implementation CLOrderDetailHeaderViewModel

- (instancetype) init {
    
    self = [super init];
    if (self) {
        self.lineArrays = [NSMutableArray new];
        self.dotArrays = [NSMutableArray new];
        self.basicArrays = [NSMutableArray new];
    }
    return self;
}

@end
