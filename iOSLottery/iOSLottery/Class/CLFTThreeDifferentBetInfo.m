//
//  CLFTThreeDifferentBetInfo.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/23.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFTThreeDifferentBetInfo.h"
@interface CLFTThreeDifferentBetInfo ()

@end
@implementation CLFTThreeDifferentBetInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bonus = 40;
    }
    return self;
}
- (void)addBetTerm:(NSString *)betTerm{
    
    if ([self.threeDifferentBetArray indexOfObject:betTerm] == NSNotFound) {
        [self.threeDifferentBetArray addObject:betTerm];
    }
}
- (void)removeBetTerm:(NSString *)betTerm{
    
    if ([self.threeDifferentBetArray indexOfObject:betTerm] != NSNotFound) {
        [self.threeDifferentBetArray removeObject:betTerm];
    }
}

#pragma mark ------ getter Mothed ------
- (NSString *)orderBetNumber{
    
    [CLTools sortSequenceWithArray:self.threeDifferentBetArray];
    NSString *orderNumber = [self.threeDifferentBetArray componentsJoinedByString:@" "];
    return [NSString stringWithFormat:@"%@%@", orderNumber, ft_order_diffThree];
}
- (CLFTBetType)betType{
    
    return CLFTBetTypeThreeDifferent;
}
- (NSInteger)playMothedType{
    
    return CLFastThreePlayMothedTypeThreeDifferent;
}
- (NSString *)betNumber{
    
    [CLTools sortSequenceWithArray:self.threeDifferentBetArray];
    NSString *betNumberStr = [self.threeDifferentBetArray componentsJoinedByString:@" "];
    return betNumberStr;
}
- (NSInteger)betNote{
    
    NSInteger note = 0;
    NSInteger count = self.threeDifferentBetArray.count;
    if (count > 2) {
        note = ((count) * (count - 1) * (count - 2)) / ((3) * (2) * (1));
    }
    return note;
}
- (NSInteger)minBetBonus{
    
    return self.betNote > 0 ? self.bonus : 0;
}
- (NSInteger)MaxBetBonus{
    
    return self.betNote > 0 ? self.bonus : 0;
}
- (NSMutableArray *)threeDifferentBetArray{
    
    if (!_threeDifferentBetArray) {
        _threeDifferentBetArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _threeDifferentBetArray;
}

@end
