//
//  CLFTDanThreeDifferentBetInfo.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/23.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFTDanThreeDifferentBetInfo.h"
@interface CLFTDanThreeDifferentBetInfo ()


@end
@implementation CLFTDanThreeDifferentBetInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bonus = 40;
    }
    return self;
}
- (void)addBetTerm:(NSString *)betTerm{
    
    if ([betTerm hasPrefix:@"*"]) {
        if ([self.danThreeDifferentBetArray indexOfObject:[betTerm substringFromIndex:1]] == NSNotFound) {
            [self.danThreeDifferentBetArray addObject:[betTerm substringFromIndex:1]];
        }
    }else{
        if ([self.tuoThreeDifferentBetArray indexOfObject:betTerm] == NSNotFound) {
            [self.tuoThreeDifferentBetArray addObject:betTerm];
        }
    }
    
}
- (void)removeBetTerm:(NSString *)betTerm{
    
    if ([betTerm hasPrefix:@"*"]) {
        if ([self.danThreeDifferentBetArray indexOfObject:[betTerm substringFromIndex:1]] != NSNotFound) {
            [self.danThreeDifferentBetArray removeObject:[betTerm substringFromIndex:1]];
        }
    }else{
        if ([self.tuoThreeDifferentBetArray indexOfObject:betTerm] != NSNotFound) {
            [self.tuoThreeDifferentBetArray removeObject:betTerm];
        }
    }
}
#pragma mark ------ getter Mothed ------
- (NSString *)orderBetNumber{
    
    [CLTools sortSequenceWithArray:self.danThreeDifferentBetArray];
    [CLTools sortSequenceWithArray:self.tuoThreeDifferentBetArray];
    NSString *orderDanNumber = [self.danThreeDifferentBetArray componentsJoinedByString:@" "];
    NSString *orderTuoNumber = [self.tuoThreeDifferentBetArray componentsJoinedByString:@" "];
    return [NSString stringWithFormat:@"(%@)%@%@", orderDanNumber, orderTuoNumber, ft_order_diffThree];
}
- (CLFTBetType)betType{
    
    return CLFTBetTypeDanTuoThreeDifferent;
}
- (NSInteger)playMothedType{
    
    return CLFastThreePlayMothedTypeDanTuoThreeDifferent;
}
- (NSString *)betNumber{
    
    [CLTools sortSequenceWithArray:self.danThreeDifferentBetArray];
    [CLTools sortSequenceWithArray:self.tuoThreeDifferentBetArray];
    NSString *danBetNumberStr = [self.danThreeDifferentBetArray componentsJoinedByString:@" "];
    NSString *tuoBetNumberStr = [self.tuoThreeDifferentBetArray componentsJoinedByString:@" "];
    return [NSString stringWithFormat:@"(%@)%@", danBetNumberStr, tuoBetNumberStr];
}
- (NSInteger)betNote{
    
    NSInteger note = 0;
    if (self.danThreeDifferentBetArray.count == 1) {
        if (self.tuoThreeDifferentBetArray.count > 1) {
            note = 1 * ((self.tuoThreeDifferentBetArray.count * (self.tuoThreeDifferentBetArray.count - 1)) / (2 * 1));
        }
    }else if (self.danThreeDifferentBetArray.count == 2){
        if (self.tuoThreeDifferentBetArray.count > 0) {
            note = self.tuoThreeDifferentBetArray.count;
        }
    }
    return note;
}
- (NSInteger)minBetBonus{
    
    return self.betNote > 0 ? self.bonus : 0;
}
- (NSInteger)MaxBetBonus{
    
    return self.betNote > 0 ? self.bonus : 0;
}
- (NSMutableArray *)danThreeDifferentBetArray{
    
    if (!_danThreeDifferentBetArray) {
        _danThreeDifferentBetArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _danThreeDifferentBetArray;
}
- (NSMutableArray *)tuoThreeDifferentBetArray{
    
    if (!_tuoThreeDifferentBetArray) {
        _tuoThreeDifferentBetArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _tuoThreeDifferentBetArray;
}

@end
