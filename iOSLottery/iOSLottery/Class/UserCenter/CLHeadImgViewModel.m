//
//  CLHeadImgViewModel.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/23.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLHeadImgViewModel.h"

@implementation CLHeadImgViewModel

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.selectStatus = NO;
    }
    return self;
}

@end


@implementation CLHeadImgTypeViewModel

+ (NSDictionary *)objectClassInArray {
    
    return @{@"img_list":@"CLHeadImgViewModel"};
}

@end
