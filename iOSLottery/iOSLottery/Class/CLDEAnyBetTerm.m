//
//  CLDEAnyBetTerm.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/5.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLDEAnyBetTerm.h"
#import "CLDEBonusInfo.h"

@implementation CLDEAnyBetTerm
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.betTermArray = [NSMutableArray arrayWithCapacity:0];
        self.bonusInfo = [[CLDEBonusInfo alloc] init];
    }
    return self;
}
#pragma mark ------------ private Mothed ------------
#pragma mark - 任选二的最小奖金
- (NSInteger)anyTwoMinBonus{
    
    if (self.betTermArray.count <= 8) {
        return self.betNote > 0 ? self.bonusInfo.bonus_de_anyTwo : 0;
    }else if (self.betTermArray.count == 9){
        return self.bonusInfo.bonus_de_anyTwo * 3;
    }else if (self.betTermArray.count == 10){
        return self.bonusInfo.bonus_de_anyTwo * 6;
    }else if (self.betTermArray.count == 11){
        return self.bonusInfo.bonus_de_anyTwo * 10;
    }
    return 0;
}
#pragma mark - 任选三的最小奖金
- (NSInteger)anyThreeMinBonus{
    
    if (self.betTermArray.count <= 9) {
        return self.betNote > 0 ? self.bonusInfo.bonus_de_anyThree : 0;
    }else if (self.betTermArray.count == 10){
        return self.bonusInfo.bonus_de_anyThree * 4;
    }else if (self.betTermArray.count == 11){
        return self.bonusInfo.bonus_de_anyThree * 10;
    }
    return 0;
}
#pragma mark - 任选四的最小奖金
- (NSInteger)anyFourMinBonus{
    
    if (self.betTermArray.count <= 10) {
        return self.betNote > 0 ? self.bonusInfo.bonus_de_anyFour : 0;
    }else if (self.betTermArray.count == 11){
        return self.bonusInfo.bonus_de_anyFour * 5;
    }
    return 0;
}

#pragma mark - 返回任选5的奖金
- (NSInteger)anyFiveBonus{
    
    return self.betNote > 0 ? self.bonusInfo.bonus_de_anyFive : 0;
}
#pragma mark - 返回任选6的奖金
- (NSInteger)anySixBonus{
    
    return self.betNote > 0 ? (self.betTermArray.count - 5) * self.bonusInfo.bonus_de_anySix : 0;
}
#pragma mark - 返回任选7的奖金
- (NSInteger)anySevenBonus{
    
    NSInteger maxBonusNote = self.betTermArray.count - 5;//最大中奖的注数
    return self.betNote > 0 ? ((maxBonusNote * (maxBonusNote - 1)) / (2 * 1)) * self.bonusInfo.bonus_de_anySeven : 0;
}
#pragma mark - 返回任选8的奖金
- (NSInteger)anyEightBonus{
    
    NSInteger maxBonusNote = self.betTermArray.count - 5;//最大中奖的注数
    return self.betNote > 0 ? ((maxBonusNote * (maxBonusNote - 1) * (maxBonusNote - 2)) / (3 * 2 * 1)) * self.bonusInfo.bonus_de_anyEight : 0;
}
#pragma mark - 获取对应玩法的投注后缀
- (NSString *)getPlayMothedOrderSuffix{
    
    switch (self.playMothedType) {
        case CLDElevenPlayMothedTypeTwo:
            return de_order_anyTwo;
            break;
        case CLDElevenPlayMothedTypeThree:
            return de_order_anyThree;
            break;
        case CLDElevenPlayMothedTypeFour:
            return de_order_anyFour;
            break;
        case CLDElevenPlayMothedTypeFive:
            return de_order_anyFive;
            break;
        case CLDElevenPlayMothedTypeSix:
            return de_order_anySix;
            break;
        case CLDElevenPlayMothedTypeSeven:
            return de_order_anySeven;
            break;
        case CLDElevenPlayMothedTypeEight:
            return de_order_anyEight;
            break;
        case CLDElevenPlayMothedTypePreOne:
            return de_order_preOne;
            break;
        case CLDElevenPlayMothedTypePreTwoGroup:
            return de_order_preTwoGroup;
            break;
        case CLDElevenPlayMothedTypePreThreeGroup:
            return de_order_preThreeGroup;
            break;
        default:
            break;
    }
    return @"";
}

#pragma mark ------------ getter Mothed ------------
#pragma mark - 返回投注号码 （用于投注详情展示）
- (NSString *)betNumber{
    
    [CLTools sortSequenceWithArray:self.betTermArray];
    return [self.betTermArray componentsJoinedByString:@" "];
}
#pragma mark - 返回投注的注数
- (NSInteger)betNote{
    
    switch (self.playMothedType) {
        case CLDElevenPlayMothedTypeTwo:
            return (self.betTermArray.count * (self.betTermArray.count - 1)) / (2 * 1);
            break;
        case CLDElevenPlayMothedTypeThree:
            return (self.betTermArray.count * (self.betTermArray.count - 1) * (self.betTermArray.count - 2)) / (3 * 2 * 1);
            break;
        case CLDElevenPlayMothedTypeFour:
            return (self.betTermArray.count * (self.betTermArray.count - 1) * (self.betTermArray.count - 2) * (self.betTermArray.count - 3)) / (4 * 3 * 2 * 1);
            break;
        case CLDElevenPlayMothedTypeFive:
            return (self.betTermArray.count * (self.betTermArray.count - 1) * (self.betTermArray.count - 2) * (self.betTermArray.count - 3) * (self.betTermArray.count - 4)) / (5 * 4 * 3 * 2 * 1);
            break;
        case CLDElevenPlayMothedTypeSix:
            return (self.betTermArray.count * (self.betTermArray.count - 1) * (self.betTermArray.count - 2) * (self.betTermArray.count - 3) * (self.betTermArray.count - 4) * (self.betTermArray.count - 5)) / (6 * 5 * 4 * 3 * 2 * 1);
            break;
        case CLDElevenPlayMothedTypeSeven:
            return (self.betTermArray.count * (self.betTermArray.count - 1) * (self.betTermArray.count - 2) * (self.betTermArray.count - 3) * (self.betTermArray.count - 4) * (self.betTermArray.count - 5) * (self.betTermArray.count - 6)) / (7 * 6 * 5 * 4 * 3 * 2 * 1);
            break;
        case CLDElevenPlayMothedTypeEight:
            return (self.betTermArray.count * (self.betTermArray.count - 1) * (self.betTermArray.count - 2) * (self.betTermArray.count - 3) * (self.betTermArray.count - 4) * (self.betTermArray.count - 5) * (self.betTermArray.count - 6)  * (self.betTermArray.count - 7)) / (8 * 7 * 6 * 5 * 4 * 3 * 2 * 1);
            break;
        case CLDElevenPlayMothedTypePreOne:
            return self.betTermArray.count;
            break;
        case CLDElevenPlayMothedTypePreTwoGroup:
            return (self.betTermArray.count * (self.betTermArray.count - 1)) / (2 * 1);
            break;
        case CLDElevenPlayMothedTypePreThreeGroup:
            return (self.betTermArray.count * (self.betTermArray.count - 1) * (self.betTermArray.count - 2)) / (3 * 2 * 1);
            break;
        default:
            break;
    }
    return 0;
}
#pragma mark - 最小奖金
- (NSInteger)minBetBonus{
    
    switch (self.playMothedType) {
        case CLDElevenPlayMothedTypeTwo:
            return [self anyTwoMinBonus];
            break;
        case CLDElevenPlayMothedTypeThree:
            return [self anyThreeMinBonus];
            break;
        case CLDElevenPlayMothedTypeFour:
            return [self anyFourMinBonus];
            break;
        case CLDElevenPlayMothedTypeFive:
            return [self anyFiveBonus];
            break;
        case CLDElevenPlayMothedTypeSix:
            return [self anySixBonus];
            break;
        case CLDElevenPlayMothedTypeSeven:
            return [self anySevenBonus];
            break;
        case CLDElevenPlayMothedTypeEight:
            return [self anyEightBonus];
            break;
        case CLDElevenPlayMothedTypePreOne:
            return self.betNote > 0 ? self.bonusInfo.bonus_de_preOne : 0;
            break;
        case CLDElevenPlayMothedTypePreTwoGroup:
            return self.betNote > 0 ? self.bonusInfo.bonus_de_preTwoGroup : 0;
            break;
        case CLDElevenPlayMothedTypePreThreeGroup:
            return self.betNote > 0 ? self.bonusInfo.bonus_de_preThreeGroup : 0;
            break;
        default:
            break;
    }
    return 0;
}
#pragma mark - 最大奖金
- (NSInteger)MaxBetBonus{
    
    switch (self.playMothedType) {
        case CLDElevenPlayMothedTypeTwo:
            return self.betNote > 10 ? self.bonusInfo.bonus_de_anyTwo * 10 : self.betNote * self.bonusInfo.bonus_de_anyTwo;
            break;
        case CLDElevenPlayMothedTypeThree:
            return self.betNote > 10 ? self.bonusInfo.bonus_de_anyThree * 10 : self.betNote * self.bonusInfo.bonus_de_anyThree;
            break;
        case CLDElevenPlayMothedTypeFour:
            return self.betNote > 10 ? self.bonusInfo.bonus_de_anyFour * 5 : self.betNote * self.bonusInfo.bonus_de_anyFour;
            break;
        case CLDElevenPlayMothedTypeFive:
            return [self anyFiveBonus];
            break;
        case CLDElevenPlayMothedTypeSix:
            return [self anySixBonus];
            break;
        case CLDElevenPlayMothedTypeSeven:
            return [self anySevenBonus];
            break;
        case CLDElevenPlayMothedTypeEight:
            return [self anyEightBonus];
            break;
        case CLDElevenPlayMothedTypePreOne:
            return self.betNote > 0 ? self.bonusInfo.bonus_de_preOne : 0;
            break;
        case CLDElevenPlayMothedTypePreTwoGroup:
            return self.betNote > 0 ? self.bonusInfo.bonus_de_preTwoGroup : 0;
            break;
        case CLDElevenPlayMothedTypePreThreeGroup:
            return self.betNote > 0 ? self.bonusInfo.bonus_de_preThreeGroup : 0;
            break;
        default:
            break;
    }
    return 0;
}
#pragma mark - 获取创建订单时的字符串
- (NSString *)orderBetNumber{
    
    [CLTools sortSequenceWithArray:self.betTermArray];
    
    return self.betNote ? [NSString stringWithFormat:@"%@%@", [self.betTermArray componentsJoinedByString:@" "] , [self getPlayMothedOrderSuffix]] : @"";
}


@end
