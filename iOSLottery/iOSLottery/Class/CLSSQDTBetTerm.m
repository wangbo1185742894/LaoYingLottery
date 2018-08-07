//
//  CLSSQDTBetTerm.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/4.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLSSQDTBetTerm.h"
#import "CLSSQConfigMessage.h"
#import "CLTools.h"
@implementation CLSSQDTBetTerm

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.redDanArray = [NSMutableArray arrayWithCapacity:0];
        self.redTuoArray = [NSMutableArray arrayWithCapacity:0];
        self.blueArray = [NSMutableArray arrayWithCapacity:0];
        self.playMothedType = CLSSQPlayMothedTypeDanTuo;
    }
    return self;
}

- (NSString *)betNumber{
    
    [CLTools sortSequenceWithArray:self.redDanArray];
    [CLTools sortSequenceWithArray:self.redTuoArray];
    [CLTools sortSequenceWithArray:self.blueArray];
    
    NSString *redDan = [self.redDanArray componentsJoinedByString:@" "];
    NSString *redTuo = [self.redTuoArray componentsJoinedByString:@" "];
    NSString *blue = [self.blueArray componentsJoinedByString:@" "];
    
    return [NSString stringWithFormat:@"(%@)%@*%@", redDan,redTuo, blue];
}

- (NSInteger)betNote{
    
    if (self.redDanArray.count > 0) {
        if (self.redTuoArray.count > 0) {
            if (self.redTuoArray.count + self.redDanArray.count >= 6 ) {
                if (self.blueArray.count > 0) {
                    return [CLTools getPermutationCombinationNumber:self.redTuoArray.count needCount:6 - self.redDanArray.count] * self.blueArray.count;
                }
            }
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
    
    [CLTools sortSequenceWithArray:self.redDanArray];
    [CLTools sortSequenceWithArray:self.redTuoArray];
    [CLTools sortSequenceWithArray:self.blueArray];
    
    NSString *redDan = [self.redDanArray componentsJoinedByString:@" "];
    NSString *redTuo = [self.redTuoArray componentsJoinedByString:@" "];
    NSString *blue = [self.blueArray componentsJoinedByString:@" "];
    
    return [NSString stringWithFormat:@"(%@)%@:%@", redDan,redTuo, blue];
}

@end
