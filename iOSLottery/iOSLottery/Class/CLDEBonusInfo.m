//
//  CLDEBonusInfo.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/13.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLDEBonusInfo.h"

@implementation CLDEBonusInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.bonus_de_preOne = 13;
        self.bonus_de_preTwoGroup = 65;
        self.bonus_de_preTwoDirect = 130;
        self.bonus_de_preThreeGroup = 195;
        self.bonus_de_preThreeDirect = 1170;
        self.bonus_de_anyTwo = 6;
        self.bonus_de_anyThree = 19;
        self.bonus_de_anyFour = 78;
        self.bonus_de_anyFive = 540;
        self.bonus_de_anySix = 90;
        self.bonus_de_anySeven = 26;
        self.bonus_de_anyEight = 9;
    }
    return self;
}
- (void)setBonusInfoData:(NSDictionary *)bonusInfo{
    
    
    if ([bonusInfo[@"1"] longValue] > 0) {
        self.bonus_de_preOne = [bonusInfo[@"1"] longValue];
    }
    if ([bonusInfo[@"2"] longValue] > 0) {
        self.bonus_de_preTwoGroup = [bonusInfo[@"2"] longValue];
    }
    if ([bonusInfo[@"3"] longValue] > 0) {
        self.bonus_de_preTwoDirect = [bonusInfo[@"3"] longValue];
    }
    if ([bonusInfo[@"4"] longValue] > 0) {
        self.bonus_de_preThreeGroup = [bonusInfo[@"4"] longValue];
    }
    if ([bonusInfo[@"5"] longValue] > 0) {
        self.bonus_de_preThreeDirect = [bonusInfo[@"5"] longValue];
    }
    if ([bonusInfo[@"6"] longValue] > 0) {
        self.bonus_de_anyTwo = [bonusInfo[@"6"] longValue];
    }
    if ([bonusInfo[@"7"] longValue] > 0) {
        self.bonus_de_anyThree = [bonusInfo[@"7"] longValue];
    }
    if ([bonusInfo[@"8"] longValue] > 0) {
        self.bonus_de_anyFour = [bonusInfo[@"8"] longValue];
    }
    if ([bonusInfo[@"9"] longValue] > 0) {
        self.bonus_de_anyFive = [bonusInfo[@"9"] longValue];
    }
    if ([bonusInfo[@"10"] longValue] > 0) {
        self.bonus_de_anySix = [bonusInfo[@"10"] longValue];
    }
    if ([bonusInfo[@"11"] longValue] > 0) {
        self.bonus_de_anySeven = [bonusInfo[@"11"] longValue];
    }
    if ([bonusInfo[@"12"] longValue] > 0) {
        self.bonus_de_anyEight = [bonusInfo[@"12"] longValue];
    }
}
@end
