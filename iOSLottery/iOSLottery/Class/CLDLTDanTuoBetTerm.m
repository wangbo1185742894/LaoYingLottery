//
//  CLDLTDanTuoBetTerm.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLDLTDanTuoBetTerm.h"
#import "CLSSQConfigMessage.h"
#import "CLTools.h"
@implementation CLDLTDanTuoBetTerm

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.redDanArray = [NSMutableArray arrayWithCapacity:0];
        self.redTuoArray = [NSMutableArray arrayWithCapacity:0];
        self.blueDanArray = [NSMutableArray arrayWithCapacity:0];
        self.blueTuoArray = [NSMutableArray arrayWithCapacity:0];
        self.playMothedType = CLSSQPlayMothedTypeDanTuo;
    }
    return self;
}

- (NSString *)betNumber{
    
    [CLTools sortSequenceWithArray:self.redDanArray];
    [CLTools sortSequenceWithArray:self.redTuoArray];
    [CLTools sortSequenceWithArray:self.blueDanArray];
    [CLTools sortSequenceWithArray:self.blueTuoArray];
    
    NSString *redDan = [self.redDanArray componentsJoinedByString:@" "];
    NSString *redTuo = [self.redTuoArray componentsJoinedByString:@" "];
    NSString *blueDan = [self.blueDanArray componentsJoinedByString:@" "];
    NSString *blueTuo = [self.blueTuoArray componentsJoinedByString:@" "];
    
    
    
    if (blueDan.length > 0) {
        return [NSString stringWithFormat:@"(%@)%@*(%@)%@", redDan,redTuo, blueDan, blueTuo];
    }else{
        return [NSString stringWithFormat:@"(%@)%@*%@", redDan,redTuo, blueTuo];
    }
    
    
}

- (NSInteger)betNote{
    
    if (self.redDanArray.count > 0) {
        if (self.redTuoArray.count > 1) {
            if (self.redTuoArray.count + self.redDanArray.count >= 5 ) {
                if (self.blueDanArray.count < 2) {
                    if (self.blueTuoArray.count > 1) {
                        if (self.blueTuoArray.count + self.blueDanArray.count > 1) {
                            return [CLTools getPermutationCombinationNumber:self.redTuoArray.count needCount:5 - self.redDanArray.count] * [CLTools getPermutationCombinationNumber:self.blueTuoArray.count needCount:2 - self.blueDanArray.count];
                        }
                    }
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
    [CLTools sortSequenceWithArray:self.blueDanArray];
    [CLTools sortSequenceWithArray:self.blueTuoArray];
    
    NSString *redDan = [self.redDanArray componentsJoinedByString:@" "];
    NSString *redTuo = [self.redTuoArray componentsJoinedByString:@" "];
    NSString *blueDan = [self.blueDanArray componentsJoinedByString:@" "];
    NSString *blueTuo = [self.blueTuoArray componentsJoinedByString:@" "];
    
    if (blueDan.length > 0) {
        return [NSString stringWithFormat:@"(%@)%@:(%@)%@", redDan,redTuo, blueDan, blueTuo];
    }else{
        return [NSString stringWithFormat:@"(%@)%@:%@", redDan,redTuo, blueTuo];
    }
}

@end
