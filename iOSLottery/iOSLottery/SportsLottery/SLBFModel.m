//
//  SLBiFenModel.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/17.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLBFModel.h"

@implementation SLBFModel

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _playName = @"比分";
    }
    return self;
}

@end

@implementation SLBF_SPModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName
{

    return @{@"sp_1_0":@"1_0", @"sp_2_0":@"2_0", @"sp_2_1":@"2_1", @"sp_3_0":@"3_0", @"sp_3_1":@"3_1", @"sp_3_2":@"3_2", @"sp_4_0":@"4_0", @"sp_4_1":@"4_1", @"sp_4_2":@"4_2", @"sp_5_0":@"5_0", @"sp_5_1":@"5_1", @"sp_5_2":@"5_2", @"sp_9_0":@"9_0", @"sp_0_0":@"0_0", @"sp_1_1":@"1_1", @"sp_2_2":@"2_2", @"sp_3_3":@"3_3", @"sp_9_9":@"9_9", @"sp_0_1":@"0_1", @"sp_0_2":@"0_2", @"sp_1_2":@"1_2", @"sp_0_3":@"0_3", @"sp_1_3":@"1_3", @"sp_2_3":@"2_3", @"sp_0_4":@"0_4", @"sp_1_4":@"1_4", @"sp_2_4":@"2_4", @"sp_0_5":@"0_5", @"sp_1_5":@"1_5", @"sp_2_5":@"2_5", @"sp_0_9":@"0_9",};


}

@end
