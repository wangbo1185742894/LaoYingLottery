//
//  SLBQCModel.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/17.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLBQCModel.h"

@implementation SLBQCModel

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _playName = @"半全场";
    }
    return self;
}
@end

@implementation SLBQC_SPModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{

    return @{@"sp_3_3":@"3_3", @"sp_3_1":@"3_1", @"sp_3_0":@"3_0", @"sp_1_3":@"1_3", @"sp_1_1":@"1_1", @"sp_1_0":@"1_0", @"sp_0_3":@"0_3", @"sp_0_1":@"0_1", @"sp_0_0":@"0_0"};

}

@end
