//
//  CLDLTNormalBetTerm.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLDLTNormalBetTerm.h"
#import "CLSSQConfigMessage.h"
#import "CLTools.h"

@implementation CLDLTNormalBetTerm


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.redArray = [NSMutableArray arrayWithCapacity:0];
        self.blueArray = [NSMutableArray arrayWithCapacity:0];
        self.playMothedType = CLSSQPlayMothedTypeNormal;
    }
    return self;
}

- (NSString *)betNumber{
    
    [CLTools sortSequenceWithArray:self.redArray];
    [CLTools sortSequenceWithArray:self.blueArray];
    
    NSString *red = [self.redArray componentsJoinedByString:@" "];
    NSString *blue = [self.blueArray componentsJoinedByString:@" "];
    
    return [NSString stringWithFormat:@"%@*%@", red, blue];
}

- (NSInteger)betNote{
    
    if (self.redArray.count >= 5) {
        if (self.blueArray.count >= 2) {
            return [CLTools getPermutationCombinationNumber:self.redArray.count needCount:5] * [CLTools getPermutationCombinationNumber:self.blueArray.count needCount:2];
        }
    }
    return 0;
}

- (NSInteger)minBetBonus{
    
    return 2 * self.betNote;
}

- (NSInteger)MaxBetBonus{
    
    return 2 * self.betNote;
}

- (NSString *)orderBetNumber{
    
    [CLTools sortSequenceWithArray:self.redArray];
    [CLTools sortSequenceWithArray:self.blueArray];
    
    NSString *red = [self.redArray componentsJoinedByString:@" "];
    NSString *blue = [self.blueArray componentsJoinedByString:@" "];
    
    return [NSString stringWithFormat:@"%@:%@", red, blue];
}

@end
