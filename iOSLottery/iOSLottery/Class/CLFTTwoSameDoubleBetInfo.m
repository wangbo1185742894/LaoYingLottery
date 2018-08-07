//
//  CLFTTwoSameDoubleBetInfo.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/23.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFTTwoSameDoubleBetInfo.h"
@interface CLFTTwoSameDoubleBetInfo ()

@end
@implementation CLFTTwoSameDoubleBetInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bonus = 15;
    }
    return self;
}
- (void)addBetTerm:(NSString *)betTerm{
    
    if ([self.twoSameDoubleBetArray indexOfObject:betTerm] == NSNotFound) {
        [self.twoSameDoubleBetArray addObject:betTerm];
    }
}
- (void)removeBetTerm:(NSString *)betTerm{
    
    if ([self.twoSameDoubleBetArray indexOfObject:betTerm] != NSNotFound) {
        [self.twoSameDoubleBetArray removeObject:betTerm];
    }
}

#pragma mark ------ getter Mothed ------
- (NSString *)orderBetNumber{
    
    [CLTools sortSequenceWithArray:self.twoSameDoubleBetArray];
    NSString *orderNumber = [self.twoSameDoubleBetArray componentsJoinedByString:@"_"];
    return [NSString stringWithFormat:@"%@%@", orderNumber, ft_order_sameTwoAll];
}
- (CLFTBetType)betType{
    
    return CLFTBetTypeTwoSameDouble;
}
- (NSInteger)playMothedType{
    
    return CLFastThreePlayMothedTypeTwoSame;
}
- (NSString *)betNumber{
    
    [CLTools sortSequenceWithArray:self.twoSameDoubleBetArray];
    NSString *betNumberStr = [self.twoSameDoubleBetArray componentsJoinedByString:@" "];
    return betNumberStr;
}
- (NSInteger)betNote{
    
    return self.twoSameDoubleBetArray.count;
}
- (NSInteger)minBetBonus{
    
    return self.twoSameDoubleBetArray.count > 0 ? self.bonus : 0;
}
- (NSInteger)MaxBetBonus{
    
    return self.twoSameDoubleBetArray.count > 0 ? self.bonus : 0;
}
- (NSMutableArray *)twoSameDoubleBetArray{
    
    if (!_twoSameDoubleBetArray) {
        _twoSameDoubleBetArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _twoSameDoubleBetArray;
}


@end
