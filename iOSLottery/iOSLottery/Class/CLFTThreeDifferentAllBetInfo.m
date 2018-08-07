//
//  CLFTThreeDifferentAllBetInfo.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/23.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFTThreeDifferentAllBetInfo.h"
@interface CLFTThreeDifferentAllBetInfo()

@end
@implementation CLFTThreeDifferentAllBetInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bonus = 10;
    }
    return self;
}
- (void)addBetTerm:(NSString *)betTerm{
    
    if ([self.threeDifferentAllArray indexOfObject:betTerm] == NSNotFound) {
        [self.threeDifferentAllArray addObject:betTerm];
    }
}
- (void)removeBetTerm:(NSString *)betTerm{
    
    if ([self.threeDifferentAllArray indexOfObject:betTerm] != NSNotFound) {
        [self.threeDifferentAllArray removeObject:betTerm];
    }
}
#pragma mark ------ getter Mothed ------
- (NSString *)orderBetNumber{
    
    [CLTools sortSequenceWithArray:self.threeDifferentAllArray];
    return [NSString stringWithFormat:@"%@", ft_order_abcThreeAll];
}
- (CLFTBetType)betType{
    
    return CLFTBetTypeThreeDifferentContinuous;
}
- (NSInteger)playMothedType{
    
    return CLFastThreePlayMothedTypeThreeDifferent;
}
- (NSString *)betNumber{
    
    [CLTools sortSequenceWithArray:self.threeDifferentAllArray];
    NSString *betNumberStr = [self.threeDifferentAllArray componentsJoinedByString:@" "];
    return betNumberStr;
}
- (NSInteger)betNote{
    
    return self.threeDifferentAllArray.count;
}
- (NSInteger)minBetBonus{
    
    return self.threeDifferentAllArray.count > 0 ? self.bonus : 0;
}
- (NSInteger)MaxBetBonus{
    
    return self.threeDifferentAllArray.count > 0 ? self.bonus : 0;
}
- (NSMutableArray *)threeDifferentAllArray{
    
    if (!_threeDifferentAllArray) {
        _threeDifferentAllArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _threeDifferentAllArray;
}

@end
