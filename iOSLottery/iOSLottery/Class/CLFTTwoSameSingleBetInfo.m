//
//  CLFTTwoSameSingleBetInfo.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/23.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFTTwoSameSingleBetInfo.h"
@interface CLFTTwoSameSingleBetInfo ()

@end
@implementation CLFTTwoSameSingleBetInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bonus = 80;
    }
    return self;
}
- (void)addBetTerm:(NSString *)betTerm{
    if (betTerm.length == 2) {
        if ([self.sameNumberBetArray indexOfObject:betTerm] == NSNotFound) {
            [self.sameNumberBetArray addObject:betTerm];
        }
    }else if (betTerm.length == 1){
        if ([self.singleBetArray indexOfObject:betTerm] == NSNotFound) {
            [self.singleBetArray addObject:betTerm];
        }
    }
    
}
- (void)removeBetTerm:(NSString *)betTerm{
    
    if (betTerm.length == 2) {
        if ([self.sameNumberBetArray indexOfObject:betTerm] != NSNotFound) {
            [self.sameNumberBetArray removeObject:betTerm];
        }
    }else if (betTerm.length == 1){
        if ([self.singleBetArray indexOfObject:betTerm] != NSNotFound) {
            [self.singleBetArray removeObject:betTerm];
        }
    }
}

#pragma mark ------ getter Mothed ------
- (NSString *)orderBetNumber{
    
    [CLTools sortSequenceWithArray:self.singleBetArray];
    [CLTools sortSequenceWithArray:self.sameNumberBetArray];
    NSString *sameNumberStr = [self.sameNumberBetArray componentsJoinedByString:@" "];
    NSString *singleNumberStr = [self.singleBetArray componentsJoinedByString:@" "];
    return [NSString stringWithFormat:@"%@#%@%@", sameNumberStr, singleNumberStr, ft_order_sameTwoSingle];
}
- (CLFTBetType)betType{
    
    return CLFTBetTypeTwoSameSingle;
}
- (NSInteger)playMothedType{
    
    return CLFastThreePlayMothedTypeTwoSame;
}
- (NSString *)betNumber{
    
    [CLTools sortSequenceWithArray:self.singleBetArray];
    [CLTools sortSequenceWithArray:self.sameNumberBetArray];
    NSString *sameNumber = [self.sameNumberBetArray componentsJoinedByString:@" "];
    NSString *singleNumber = [self.singleBetArray componentsJoinedByString:@" "];
    return [NSString stringWithFormat:@"%@#%@", sameNumber, singleNumber];
}
- (NSInteger)betNote{
    
    return self.sameNumberBetArray.count * self.singleBetArray.count;
}
- (NSInteger)minBetBonus{
    
    return self.betNote > 0 ? self.bonus : 0;
}
- (NSInteger)MaxBetBonus{
    
    return self.betNote > 0 ? self.bonus : 0;
}
- (NSMutableArray *)sameNumberBetArray{
    
    if (!_sameNumberBetArray) {
        _sameNumberBetArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _sameNumberBetArray;
}
- (NSMutableArray *)singleBetArray{
    
    if (!_singleBetArray) {
        _singleBetArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _singleBetArray;
}

@end
