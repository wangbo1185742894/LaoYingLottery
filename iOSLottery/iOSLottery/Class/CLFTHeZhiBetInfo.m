//
//  CLFTHeZhiBetInfo.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/19.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFTHeZhiBetInfo.h"
@interface CLFTHeZhiBetInfo ()

@end

@implementation CLFTHeZhiBetInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)addBetTerm:(NSString *)betTerm{
    
    if ([self.heZhiBetArray indexOfObject:betTerm] == NSNotFound) {
        [self.heZhiBetArray addObject:betTerm];
    }
}
- (void)removeBetTerm:(NSString *)betTerm{
    
    if ([self.heZhiBetArray indexOfObject:betTerm] != NSNotFound) {
        [self.heZhiBetArray removeObject:betTerm];
    }
}

#pragma mark ------ getter Mothed ------
- (NSString *)orderBetNumber{
    
    [CLTools sortSequenceWithArray:self.heZhiBetArray];
    NSString *numberStr = [self.heZhiBetArray componentsJoinedByString:@"_"];
    return [NSString stringWithFormat:@"%@%@",numberStr, ft_order_heZhi];
}
- (CLFTBetType)betType{
    
    return CLFTBetTypeHeZhi;
}
- (NSInteger)playMothedType{
    
    return CLFastThreePlayMothedTypeHeZhi;
}
- (NSString *)betNumber{
    
    [CLTools sortSequenceWithArray:self.heZhiBetArray];
    NSString *betNumberStr = [self.heZhiBetArray componentsJoinedByString:@" "];
    return betNumberStr;
}
- (NSInteger)betNote{
    
    return self.heZhiBetArray.count;
}
- (NSInteger)minBetBonus{
    
    NSInteger minBonus = 0;
    if (self.heZhiBetArray.count > 0) {
        minBonus = [self.bonusArray[[self.heZhiBetArray[0] integerValue] - 3] integerValue];
    }
    for (NSString *betTerm in self.heZhiBetArray) {
        minBonus = MIN(minBonus, [self.bonusArray[[betTerm integerValue] - 3] integerValue]);
    }
    return minBonus;
}
- (NSInteger)MaxBetBonus{
    
    NSInteger maxBonus = 0;
    if (self.heZhiBetArray.count > 0) {
        maxBonus = [self.bonusArray[[self.heZhiBetArray[0] integerValue] - 3] integerValue];
    }
    for (NSString *betTerm in self.heZhiBetArray) {
        maxBonus = MAX(maxBonus, [self.bonusArray[[betTerm integerValue] - 3] integerValue]);
    }
    return maxBonus;
}
- (NSMutableArray *)heZhiBetArray{
    
    if (!_heZhiBetArray) {
        _heZhiBetArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _heZhiBetArray;
}
- (NSMutableArray *)bonusArray{
    
    if (!_bonusArray) {
        _bonusArray = [NSMutableArray arrayWithArray:@[@"240",
                                                       @"80",
                                                       @"40",
                                                       @"25",
                                                       @"16",
                                                       @"12",
                                                       @"10",
                                                       @"9",
                                                       @"9",
                                                       @"10",
                                                       @"12",
                                                       @"16",
                                                       @"25",
                                                       @"40",
                                                       @"80",
                                                       @"240"]];
    }
    return _bonusArray;
}
@end
