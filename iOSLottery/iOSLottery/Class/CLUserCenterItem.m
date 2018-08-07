//
//  CLUserCenterItem.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/4/6.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLUserCenterItem.h"

@implementation CLUserCenterItem

- (instancetype) init {
    
    self = [super init];
    if (self) {
        self.showNeedLogin = NO;
    }
    return self;
}

+ (CLUserCenterItem *)userCenterItmeWithTitile:(NSString *)title type:(UserCenterCellType)type showNeedLogin:(BOOL)isNeed imageName:(NSString *)imageName
{
    CLUserCenterItem *item = [[CLUserCenterItem alloc] init];
    
    item.title = title;
    item.type = type;
    item.showNeedLogin = isNeed;
    item.imgStr = imageName;
    
    return item;
    
}

@end
