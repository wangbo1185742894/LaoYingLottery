//
//  CLFTTwoDifferentBetInfo.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/23.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFTTwoDifferentBetInfo.h"
@interface CLFTTwoDifferentBetInfo ()

@end
@implementation CLFTTwoDifferentBetInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bonus = 8;
    }
    return self;
}
- (void)addBetTerm:(NSString *)betTerm{
    
    if ([self.twoDifferentBetArray indexOfObject:betTerm] == NSNotFound) {
        [self.twoDifferentBetArray addObject:betTerm];
    }
}
- (void)removeBetTerm:(NSString *)betTerm{
    
    if ([self.twoDifferentBetArray indexOfObject:betTerm] != NSNotFound) {
        [self.twoDifferentBetArray removeObject:betTerm];
    }
}

#pragma mark ------ getter Mothed ------
- (NSString *)orderBetNumber{
    
    [CLTools sortSequenceWithArray:self.twoDifferentBetArray];
    NSString *orderNumber = [self.twoDifferentBetArray componentsJoinedByString:@" "];
    return [NSString stringWithFormat:@"%@%@",orderNumber, ft_order_diffTwo];
}
- (CLFTBetType)betType{
    
    return CLFTBetTypeTwoDifferent;
}
- (NSInteger)playMothedType{
    
    return CLFastThreePlayMothedTypeTwoDifferent;
}
- (NSString *)betNumber{
    
    [CLTools sortSequenceWithArray:self.twoDifferentBetArray];
    NSString *betNumberStr = [self.twoDifferentBetArray componentsJoinedByString:@" "];
    return betNumberStr;
}
- (NSInteger)betNote{
    
    NSInteger note = 0;
    NSInteger count = self.twoDifferentBetArray.count;
    if (count > 1) {
        note = ((count) * (count - 1)) / ((2) * (1));
    }
    return note;
}
- (NSInteger)minBetBonus{
    
    return self.betNote > 0 ? self.bonus : 0;
}
- (NSInteger)MaxBetBonus{

    return self.betNote > 2 ? self.bonus * 3 : self.betNote * self.bonus;
}
- (NSMutableArray *)twoDifferentBetArray{
    
    if (!_twoDifferentBetArray) {
        _twoDifferentBetArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _twoDifferentBetArray;
}

@end
