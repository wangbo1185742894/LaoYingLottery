//
//  CLFTThreeSameSingleBetInfo.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/22.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFTThreeSameSingleBetInfo.h"
@interface CLFTThreeSameSingleBetInfo ()

@end
@implementation CLFTThreeSameSingleBetInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bonus = 240;
    }
    return self;
}
- (void)addBetTerm:(NSString *)betTerm{
    
    if ([self.threeSameSingleBetArray indexOfObject:betTerm] == NSNotFound) {
        [self.threeSameSingleBetArray addObject:betTerm];
    }
}
- (void)removeBetTerm:(NSString *)betTerm{
    
    if ([self.threeSameSingleBetArray indexOfObject:betTerm] != NSNotFound) {
        [self.threeSameSingleBetArray removeObject:betTerm];
    }
}

#pragma mark ------ getter Mothed ------
- (NSString *)orderBetNumber{
    
    [CLTools sortSequenceWithArray:self.threeSameSingleBetArray];
    
    NSString *numberStr = [NSMutableString stringWithCapacity:0];
    
    
    
    for (NSString *number in self.threeSameSingleBetArray) {
        
        NSInteger numberInt = [[number substringToIndex:1] integerValue];
        
        numberStr = [numberStr stringByAppendingString:[NSString stringWithFormat:@"%@%@,", [NSString stringWithFormat:@"%zi %zi %zi", numberInt , numberInt, numberInt], ft_order_sameThreeSingle]];
    }
    
    return [numberStr substringToIndex:numberStr.length - 1];
}
- (CLFTBetType)betType{
    
    return CLFTBetTypeThreeSameSingle;
}
- (NSInteger)playMothedType{
    
    return CLFastThreePlayMothedTypeThreeSame;
}
- (NSString *)betNumber{
    
    [CLTools sortSequenceWithArray:self.threeSameSingleBetArray];
    NSString *betNumberStr = [self.threeSameSingleBetArray componentsJoinedByString:@" "];
    return betNumberStr;
}
- (NSInteger)betNote{
    
    return self.threeSameSingleBetArray.count;
}
- (NSInteger)minBetBonus{
    
    return self.threeSameSingleBetArray.count > 0 ? self.bonus : 0;
}
- (NSInteger)MaxBetBonus{
    
    return self.threeSameSingleBetArray.count > 0 ? self.bonus : 0;
}
- (NSMutableArray *)threeSameSingleBetArray{
    
    if (!_threeSameSingleBetArray) {
        _threeSameSingleBetArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _threeSameSingleBetArray;
}

@end
