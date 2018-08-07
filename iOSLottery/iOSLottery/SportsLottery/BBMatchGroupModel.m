//
//  BBMatchGroupModel.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBMatchGroupModel.h"
#import "BBMatchModel.h"

@implementation BBMatchGroupModel


+ (NSDictionary *)mj_objectClassInArray
{
    
    return @{@"matches":@"BBMatchModel"};
    
}

- (instancetype)init
{
    
    if (self = [super init]) {
        
        self.visible = YES;
        self.matches = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}


@end
