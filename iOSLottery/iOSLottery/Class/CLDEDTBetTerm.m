//
//  CLDEDTBetTerm.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/6.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLDEDTBetTerm.h"
#import "CLTools.h"
#import "CLDEBonusInfo.h"
@implementation CLDEDTBetTerm

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.danBetTermArray = [NSMutableArray arrayWithCapacity:0];
        self.tuoBetTermArray = [NSMutableArray arrayWithCapacity:0];
        self.bonusInfo = [[CLDEBonusInfo alloc] init];
    }
    return self;
}
#pragma mark ------------ private Mothed ------------
#pragma mark - DT的注数
- (NSInteger)dt_betNoteWithNumber:(NSInteger)anyNumber{
    
    if (self.danBetTermArray.count > 0 && self.danBetTermArray.count < anyNumber && (self.danBetTermArray.count + self.tuoBetTermArray.count >= anyNumber)) {
        return [CLTools getPermutationCombinationNumber:self.tuoBetTermArray.count needCount:anyNumber - self.danBetTermArray.count];
    }else{
        return 0;
    }
}
#pragma mark - 获取对应玩法的投注后缀
- (NSString *)getPlayMothedOrderSuffix{
    
    switch (self.playMothedType) {
        case CLDElevenPlayMothedTypeDTTwo:
            return de_order_anyTwo;
            break;
        case CLDElevenPlayMothedTypeDTThree:
            return de_order_anyThree;
            break;
        case CLDElevenPlayMothedTypeDTFour:
            return de_order_anyFour;
            break;
        case CLDElevenPlayMothedTypeDTFive:
            return de_order_anyFive;
            break;
        case CLDElevenPlayMothedTypeDTSix:
            return de_order_anySix;
            break;
        case CLDElevenPlayMothedTypeDTSeven:
            return de_order_anySeven;
            break;
        case CLDElevenPlayMothedTypeDTEight:
            return de_order_anyEight;
            break;
        case CLDElevenPlayMothedTypeDTPreTwoGroup:
            return de_order_preTwoGroup;
            break;
        case CLDElevenPlayMothedTypeDTPreThreeGroup:
            return de_order_preThreeGroup;
            break;
        default:
            break;
    }
    return @"";
}
#pragma mark - 任选二最小奖金
- (NSInteger)dt_anyTwoMinBonus{
    
    if (self.danBetTermArray.count == 1) {
        //必须有一个胆码
        if (self.tuoBetTermArray.count > 0 && self.tuoBetTermArray.count <= 6) {
            return self.bonusInfo.bonus_de_anyTwo;
        }else if (self.tuoBetTermArray.count > 6){
            return self.bonusInfo.bonus_de_anyTwo * (self.tuoBetTermArray.count - 6);
        }
    }
    return 0;
}
#pragma mark - 任选三最小奖金
- (NSInteger)dt_anyThreeMinBonus{
    
    if (self.danBetTermArray.count == 1) {
        //有一个胆码
        if (self.tuoBetTermArray.count >= 2 && self.tuoBetTermArray.count <= 8) {
            return self.bonusInfo.bonus_de_anyThree;
        }else if (self.tuoBetTermArray.count == 9){
            return self.bonusInfo.bonus_de_anyThree * 3;
        }else if (self.tuoBetTermArray.count == 10){
            return self.bonusInfo.bonus_de_anyThree * 6;
        }
    }else if (self.danBetTermArray.count == 2){
        //有两个胆码
        if (self.tuoBetTermArray.count >= 1 && self.tuoBetTermArray.count <= 7) {
            return self.bonusInfo.bonus_de_anyThree;
        }else if (self.tuoBetTermArray.count == 8){
            return self.bonusInfo.bonus_de_anyThree * 2;
        }else if (self.tuoBetTermArray.count == 9){
            return self.bonusInfo.bonus_de_anyThree * 3;
        }
    }
    return 0;
}
#pragma mark - 任选四最小奖金
- (NSInteger)dt_anyFourMinBonus{
    
    if (self.danBetTermArray.count == 1) {
        //有一个胆码
        if (self.tuoBetTermArray.count >= 3 && self.tuoBetTermArray.count <= 9) {
            return self.bonusInfo.bonus_de_anyFour;
        }else if (self.tuoBetTermArray.count == 10){
            return self.bonusInfo.bonus_de_anyFour * 4;
        }
    }else if (self.danBetTermArray.count == 2){
        //有2个胆码
        if (self.tuoBetTermArray.count >= 2 && self.tuoBetTermArray.count <= 8) {
            return self.bonusInfo.bonus_de_anyFour;
        }else if (self.tuoBetTermArray.count == 9){
            return self.bonusInfo.bonus_de_anyFour * 3;
        }
    }else if (self.danBetTermArray.count == 3){
        //有3个胆码
        if (self.tuoBetTermArray.count >= 1 && self.tuoBetTermArray.count <= 7) {
            return self.bonusInfo.bonus_de_anyFour;
        }else if (self.tuoBetTermArray.count == 8){
            return self.bonusInfo.bonus_de_anyFour * 2;
        }
    }
    return 0;
}

#pragma mark - 最小奖金数
/**
 返回最小奖金数

 @param anyNumber 任选 号
 @param bonusNumber 允许中奖号的个数
 @param oneBonus  单注中奖奖金

 @return 返回最小奖金
 */
- (NSInteger)getMinBonusWithNumber:(NSInteger)anyNumber bonusNumber:(NSInteger)bonusNumber oneBonus:(NSInteger)oneBonus{
    
    if (self.danBetTermArray.count >= anyNumber - bonusNumber) {
        //若 胆码个数 >= 任选号个数 -  中奖号个数  则说明拖码不能全部用来中奖，必须从胆码中取一个或多个用于中奖，此时若中奖则是唯一的 故此最小奖金只有唯一一个
        return self.betNote > 0 ? oneBonus : 0;
    }else{
        //否则 说明拖码可以用来全部中奖 则最小奖金会发生变化
        if ((self.danBetTermArray.count + self.tuoBetTermArray.count) >= anyNumber) {
            return oneBonus * [CLTools getPermutationCombinationNumber:(self.tuoBetTermArray.count - bonusNumber) needCount:(anyNumber - self.danBetTermArray.count - bonusNumber)];
        }else{
            return 0;
        }
    }
    return 0;
}
#pragma mark - 返回 玩法小于等于 5 最大奖金数
- (NSInteger)getMaxBonusLessThanFiveWithNumber:(NSInteger)anyNumber oneBonus:(NSInteger)oneBonus{
    
    //最大奖金数 是胆码全中， 拖码匹配 匹配几组中几组 即最大奖金数
    if (self.danBetTermArray.count > 0 && self.danBetTermArray.count < anyNumber) {
        
        if ((self.danBetTermArray.count + self.tuoBetTermArray.count >= anyNumber) && (self.danBetTermArray.count + self.tuoBetTermArray.count <= 5)) {
            //如果任选玩法 小于 5 并且选号个数小于等于5 则最大中奖数就是所有注数全中奖
            return oneBonus * self.betNote;
        }else if ((self.danBetTermArray.count + self.tuoBetTermArray.count > 5)){
            
            //如果胆码加拖码大于5个 则最大中奖数 是  从（5 - 胆码个数）中取 （任选 - 胆码个数） 的排列组合
            return [CLTools getPermutationCombinationNumber:(5 - self.danBetTermArray.count) needCount:(anyNumber - self.danBetTermArray.count)] * oneBonus;
        }else{
            return 0;
        }
    }else{
        return 0;
    }
}
#pragma mark - 返回大于5的玩法的最大奖金数
- (NSInteger)getMaxBonusGreaterThanFiveWithNumber:(NSInteger)anyNumber oneBonus:(NSInteger)oneBonus{
    
    //最大奖金数 是胆码全中， 拖码匹配 匹配几组中几组 即最大奖金数
    if (self.danBetTermArray.count > 0 && self.danBetTermArray.count < anyNumber && ((self.danBetTermArray.count + self.tuoBetTermArray.count) >= anyNumber)) {
        if (self.danBetTermArray.count <= 5) {
            return [CLTools getPermutationCombinationNumber:(self.tuoBetTermArray.count - (5 - self.danBetTermArray.count)) needCount:(anyNumber - 5)] * oneBonus;
        }else if (self.danBetTermArray.count > 5){
            return [CLTools getPermutationCombinationNumber:(self.tuoBetTermArray.count) needCount:(anyNumber - self.danBetTermArray.count)] * oneBonus;
        }
    }
    return 0;
}
#pragma mark ------------ getter Mothed ------------
#pragma mark - 返回投注号码 （用于投注详情展示）
- (NSString *)betNumber{
    
    [CLTools sortSequenceWithArray:self.danBetTermArray];
    [CLTools sortSequenceWithArray:self.tuoBetTermArray];
    NSString *firstStr = [self.danBetTermArray componentsJoinedByString:@" "];
    NSString *secondStr = [self.tuoBetTermArray componentsJoinedByString:@" "];
    
    return [NSString stringWithFormat:@"(%@)%@", firstStr, secondStr];
}
#pragma mark - 返回投注的注数
- (NSInteger)betNote{
    
    switch (self.playMothedType) {
        case CLDElevenPlayMothedTypeDTTwo:
            return [self dt_betNoteWithNumber:2];
            break;
        case CLDElevenPlayMothedTypeDTThree:
            return [self dt_betNoteWithNumber:3];
            break;
        case CLDElevenPlayMothedTypeDTFour:
            return [self dt_betNoteWithNumber:4];
            break;
        case CLDElevenPlayMothedTypeDTFive:
            return [self dt_betNoteWithNumber:5];
            break;
        case CLDElevenPlayMothedTypeDTSix:
            return [self dt_betNoteWithNumber:6];
            break;
        case CLDElevenPlayMothedTypeDTSeven:
            return [self dt_betNoteWithNumber:7];
            break;
        case CLDElevenPlayMothedTypeDTEight:
            return [self dt_betNoteWithNumber:8];
            break;
        case CLDElevenPlayMothedTypeDTPreTwoGroup:
            return [self dt_betNoteWithNumber:2];
            break;
        case CLDElevenPlayMothedTypeDTPreThreeGroup:
            return [self dt_betNoteWithNumber:3];
            break;
        default:
            break;
    }
    return 0;
}
#pragma mark - 最小奖金
- (NSInteger)minBetBonus{
    
    switch (self.playMothedType) {
        case CLDElevenPlayMothedTypeDTTwo:
            return [self dt_anyTwoMinBonus];
            break;
        case CLDElevenPlayMothedTypeDTThree:
            return [self dt_anyThreeMinBonus];
            break;
        case CLDElevenPlayMothedTypeDTFour:
            return [self dt_anyFourMinBonus];
            break;
        case CLDElevenPlayMothedTypeDTFive:
            return [self getMinBonusWithNumber:5 bonusNumber:5 oneBonus:self.bonusInfo.bonus_de_anyFive];
            break;
        case CLDElevenPlayMothedTypeDTSix:
            return [self getMinBonusWithNumber:6 bonusNumber:5 oneBonus:self.bonusInfo.bonus_de_anySix];
            break;
        case CLDElevenPlayMothedTypeDTSeven:
            return [self getMinBonusWithNumber:7 bonusNumber:5 oneBonus:self.bonusInfo.bonus_de_anySeven];
            break;
        case CLDElevenPlayMothedTypeDTEight:
            return [self getMinBonusWithNumber:8 bonusNumber:5 oneBonus:self.bonusInfo.bonus_de_anyEight];
            break;
        case CLDElevenPlayMothedTypeDTPreTwoGroup:
            return self.betNote > 0 ? self.bonusInfo.bonus_de_preTwoGroup : 0;
            break;
        case CLDElevenPlayMothedTypeDTPreThreeGroup:
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
        case CLDElevenPlayMothedTypeDTTwo:
            return [self getMaxBonusLessThanFiveWithNumber:2 oneBonus:self.bonusInfo.bonus_de_anyTwo];
            break;
        case CLDElevenPlayMothedTypeDTThree:
            return [self getMaxBonusLessThanFiveWithNumber:3 oneBonus:self.bonusInfo.bonus_de_anyThree];
            break;
        case CLDElevenPlayMothedTypeDTFour:
            return [self getMaxBonusLessThanFiveWithNumber:4 oneBonus:self.bonusInfo.bonus_de_anyFour];
            break;
        case CLDElevenPlayMothedTypeDTFive:
            return [self getMaxBonusLessThanFiveWithNumber:5 oneBonus:self.bonusInfo.bonus_de_anyFive];
            break;
        case CLDElevenPlayMothedTypeDTSix:
            return [self getMaxBonusGreaterThanFiveWithNumber:6 oneBonus:self.bonusInfo.bonus_de_anySix];
            break;
        case CLDElevenPlayMothedTypeDTSeven:
            return [self getMaxBonusGreaterThanFiveWithNumber:7 oneBonus:self.bonusInfo.bonus_de_anySeven];
            break;
        case CLDElevenPlayMothedTypeDTEight:
            return [self getMaxBonusGreaterThanFiveWithNumber:8 oneBonus:self.bonusInfo.bonus_de_anyEight];
            break;
        case CLDElevenPlayMothedTypeDTPreTwoGroup:
            return [self getMaxBonusGreaterThanFiveWithNumber:2 oneBonus:self.bonusInfo.bonus_de_preTwoGroup];
            break;
        case CLDElevenPlayMothedTypeDTPreThreeGroup:
            return [self getMaxBonusGreaterThanFiveWithNumber:3 oneBonus:self.bonusInfo.bonus_de_preThreeGroup];
            break;
        default:
        break;
    }
    return 0;
}
#pragma mark - 获取创建订单时的字符串
- (NSString *)orderBetNumber{
    
    [CLTools sortSequenceWithArray:self.danBetTermArray];
    [CLTools sortSequenceWithArray:self.tuoBetTermArray];
    NSString *firstStr = [self.danBetTermArray componentsJoinedByString:@" "];
    NSString *secondStr = [self.tuoBetTermArray componentsJoinedByString:@" "];
    
    return [NSString stringWithFormat:@"(%@)%@%@", firstStr, secondStr, [self getPlayMothedOrderSuffix]];
}

@end
