//
//  CLFTDanTwoDifferentBetInfo.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/23.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFTDanTwoDifferentBetInfo.h"
@interface CLFTDanTwoDifferentBetInfo ()

@end
@implementation CLFTDanTwoDifferentBetInfo
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bonus = 8;
    }
    return self;
}
- (void)addBetTerm:(NSString *)betTerm{
    
    if ([betTerm hasPrefix:@"*"]) {
        if ([self.danTwoDifferentBetArray indexOfObject:[betTerm substringFromIndex:1]] == NSNotFound) {
            [self.danTwoDifferentBetArray addObject:[betTerm substringFromIndex:1]];
        }
    }else{
        if ([self.tuoTwoDifferentBetArray indexOfObject:betTerm] == NSNotFound) {
            [self.tuoTwoDifferentBetArray addObject:betTerm];
        }
    }
    
}
- (void)removeBetTerm:(NSString *)betTerm{
    
    if ([betTerm hasPrefix:@"*"]) {
        if ([self.danTwoDifferentBetArray indexOfObject:[betTerm substringFromIndex:1]] != NSNotFound) {
            [self.danTwoDifferentBetArray removeObject:[betTerm substringFromIndex:1]];
        }
    }else{
        if ([self.tuoTwoDifferentBetArray indexOfObject:betTerm] != NSNotFound) {
            [self.tuoTwoDifferentBetArray removeObject:betTerm];
        }
    }
}
#pragma mark ------ getter Mothed ------
- (NSString *)orderBetNumber{
    
    [CLTools sortSequenceWithArray:self.danTwoDifferentBetArray];
    [CLTools sortSequenceWithArray:self.tuoTwoDifferentBetArray];
    NSString *orderDanNumber = [self.danTwoDifferentBetArray componentsJoinedByString:@" "];
    NSString *orderTuoNumber = [self.tuoTwoDifferentBetArray componentsJoinedByString:@" "];
    return [NSString stringWithFormat:@"(%@)%@%@", orderDanNumber, orderTuoNumber, ft_order_diffTwo];
}
- (CLFTBetType)betType{
    
    return CLFTBetTypeDanTuoTwoDifferent;
}
- (NSInteger)playMothedType{
    
    return CLFastThreePlayMothedTypeDanTuoTwoDifferent;
}
- (NSString *)betNumber{
    
    [CLTools sortSequenceWithArray:self.danTwoDifferentBetArray];
    [CLTools sortSequenceWithArray:self.tuoTwoDifferentBetArray];
    NSString *danBetNumberStr = [self.danTwoDifferentBetArray componentsJoinedByString:@" "];
    NSString *tuoBetNumberStr = [self.tuoTwoDifferentBetArray componentsJoinedByString:@" "];
    return [NSString stringWithFormat:@"(%@)%@", danBetNumberStr, tuoBetNumberStr];
}
- (NSInteger)betNote{
    
    NSInteger note = 0;
    if (self.danTwoDifferentBetArray.count == 1) {
        if (self.tuoTwoDifferentBetArray.count > 0) {
            note = self.tuoTwoDifferentBetArray.count;
        }
    }
    return note;
}
- (NSInteger)minBetBonus{
    
    return self.betNote > 0 ? self.bonus : 0;
}
- (NSInteger)MaxBetBonus{
    
    return self.betNote > 1 ? self.bonus * 2 : self.betNote * self.bonus;
}
- (NSMutableArray *)danTwoDifferentBetArray{
    
    if (!_danTwoDifferentBetArray) {
        _danTwoDifferentBetArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _danTwoDifferentBetArray;
}
- (NSMutableArray *)tuoTwoDifferentBetArray{
    
    if (!_tuoTwoDifferentBetArray) {
        _tuoTwoDifferentBetArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _tuoTwoDifferentBetArray;
}

@end
