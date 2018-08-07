//
//  CLFollowDetailModel.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/18.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFollowDetailModel.h"

@implementation CLFollowDetailModel

- (instancetype) init {
    
    self = [super init];
    if (self) {
        self.followOrderArrays = [NSMutableArray new];
    }
    return self;
}

@end


@implementation CLFollowDetailSectionViewModel

- (instancetype) init {
    
    self = [super init];
    if (self) {
        self.sectionArray = [NSMutableArray new];
    }
    return self;
}

@end

@implementation CLFollowDetailBaseAPIModel


/* 实现该方法，说明数组中存储的模型数据类型 */
+ (NSDictionary *)objectClassInArray{
    return @{ @"followOrderVos" : @"CLFollowDetailProgramModel"};
}

@end
