//
//  CLFTThreeSameAllBetInfo.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/22.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFTThreeSameAllBetInfo.h"
@interface CLFTThreeSameAllBetInfo ()

@end
@implementation CLFTThreeSameAllBetInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bonus = 40;
    }
    return self;
}
- (void)addBetTerm:(NSString *)betTerm{
    
    if ([self.threeSameAllBetArray indexOfObject:betTerm] == NSNotFound) {
        [self.threeSameAllBetArray addObject:betTerm];
    }
}
- (void)removeBetTerm:(NSString *)betTerm{
    
    if ([self.threeSameAllBetArray indexOfObject:betTerm] != NSNotFound) {
        [self.threeSameAllBetArray removeObject:betTerm];
    }
}

#pragma mark ------ getter Mothed ------
- (NSString *)orderBetNumber{
    
    [CLTools sortSequenceWithArray:self.threeSameAllBetArray];
    return [NSString stringWithFormat:@"%@", ft_order_sameThreeAll];
}
- (CLFTBetType)betType{
    
    return CLFTBetTypeThreeSameAll;
}
- (NSInteger)playMothedType{
    
    return CLFastThreePlayMothedTypeThreeSame;
}
- (NSString *)betNumber{
    
    [CLTools sortSequenceWithArray:self.threeSameAllBetArray];
    NSString *betNumberStr = [self.threeSameAllBetArray componentsJoinedByString:@" "];
    return betNumberStr;
}
- (NSInteger)betNote{
    
    return self.threeSameAllBetArray.count;
}
- (NSInteger)minBetBonus{
    
    return self.threeSameAllBetArray.count > 0 ? self.bonus : 0;
}
- (NSInteger)MaxBetBonus{
    
    return self.threeSameAllBetArray.count > 0 ? self.bonus : 0;
}
- (NSMutableArray *)threeSameAllBetArray{
    
    if (!_threeSameAllBetArray) {
        _threeSameAllBetArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _threeSameAllBetArray;
}

@end
