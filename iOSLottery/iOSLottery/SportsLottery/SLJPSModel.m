//
//  SLJPSModel.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/17.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLJPSModel.h"

@implementation SLJPSModel

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _playName = @"总进球";
    }
    return self;
}

@end

@implementation SLJPS_SPModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{

    return @{@"sp_0":@"0", @"sp_1":@"1", @"sp_2":@"2", @"sp_3":@"3", @"sp_4":@"4", @"sp_5":@"5", @"sp_6":@"6", @"sp_7":@"7", };

}

@end
