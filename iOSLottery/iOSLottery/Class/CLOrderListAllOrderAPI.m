//
//  CLOrderListAllOrderAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/11.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLOrderListAllOrderAPI.h"

@implementation CLOrderListAllOrderAPI


- (instancetype) init {
    
    self = [super init];
    if (self) {
        self.apiListType = CLAPIOrderListTypeALL;
    }
    return self;
}

@end
