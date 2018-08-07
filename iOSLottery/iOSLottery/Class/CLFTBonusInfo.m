//
//  CLFTBonusInfo.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/13.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFTBonusInfo.h"

@implementation CLFTBonusInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bonus_sumFour = 80;
        self.bonus_sumFive = 40;
        self.bonus_sumSix = 25;
        self.bonus_sumSeven = 16;
        self.bonus_sumEight = 12;
        self.bonus_sumNine = 10;
        self.bonus_sumTen = 9;
        self.bonus_sumEleven = 9;
        self.bonus_sumTwelve = 10;
        self.bonus_sumThirteen = 12;
        self.bonus_sumFourteen = 16;
        self.bonus_sumFifteen = 25;
        self.bonus_sumSixteen = 40;
        self.bonus_sumSeventeen = 80;
        self.bonus_threeSameAll = 40;
        self.bonus_threeSameSingle = 240;
        self.bonus_threeDiff = 40;
        self.bonus_threeDiffAll = 10;
        self.bonus_twoSameDouble = 15;
        self.bonus_twoSameSingle = 80;
        self.bonus_twoDiff = 8;
    }
    return self;
}
- (void)setBonusInfoWithData:(NSDictionary *)bonusInfoData{
    
    self.bonus_sumFour = [bonusInfoData[@"1"] longValue] > 0 ? [bonusInfoData[@"1"] longValue] : self.bonus_sumFour;
    self.bonus_sumFive = [bonusInfoData[@"2"] longValue] > 0 ? [bonusInfoData[@"2"] longValue] : self.bonus_sumFive;
    self.bonus_sumSix = [bonusInfoData[@"3"] longValue] > 0 ? [bonusInfoData[@"3"] longValue] : self.bonus_sumSix;
    self.bonus_sumSeven = [bonusInfoData[@"4"] longValue] > 0 ? [bonusInfoData[@"4"] longValue] : self.bonus_sumSeven;
    self.bonus_sumEight = [bonusInfoData[@"5"] longValue] > 0 ? [bonusInfoData[@"5"] longValue] : self.bonus_sumEight;
    self.bonus_sumNine = [bonusInfoData[@"6"] longValue] > 0 ? [bonusInfoData[@"6"] longValue] : self.bonus_sumNine;
    self.bonus_sumTen = [bonusInfoData[@"7"] longValue] > 0 ? [bonusInfoData[@"7"] longValue] : self.bonus_sumTen;
    self.bonus_sumEleven = [bonusInfoData[@"8"] longValue] > 0 ? [bonusInfoData[@"8"] longValue] : self.bonus_sumEleven;
    self.bonus_sumTwelve = [bonusInfoData[@"9"] longValue] > 0 ? [bonusInfoData[@"9"] longValue] : self.bonus_sumTwelve;
    self.bonus_sumThirteen = [bonusInfoData[@"10"] longValue] > 0 ? [bonusInfoData[@"10"] longValue] : self.bonus_sumThirteen;
    self.bonus_sumFourteen = [bonusInfoData[@"11"] longValue] > 0 ? [bonusInfoData[@"11"] longValue] : self.bonus_sumFourteen;
    self.bonus_sumFifteen = [bonusInfoData[@"12"] longValue] > 0 ? [bonusInfoData[@"12"] longValue] : self.bonus_sumFifteen;
    self.bonus_sumSixteen = [bonusInfoData[@"13"] longValue] > 0 ? [bonusInfoData[@"13"] longValue] : self.bonus_sumSixteen;
    self.bonus_sumSeventeen = [bonusInfoData[@"14"] longValue] > 0 ? [bonusInfoData[@"14"] longValue] : self.bonus_sumSeventeen;
    self.bonus_threeSameAll = [bonusInfoData[@"15"] longValue] > 0 ? [bonusInfoData[@"15"] longValue] : self.bonus_threeSameAll;
    self.bonus_threeSameSingle = [bonusInfoData[@"16"] longValue] > 0 ? [bonusInfoData[@"16"] longValue] : self.bonus_threeSameSingle;
    self.bonus_threeDiff = [bonusInfoData[@"17"] longValue] > 0 ? [bonusInfoData[@"17"] longValue] : self.bonus_threeDiff;
    self.bonus_threeDiffAll = [bonusInfoData[@"18"] longValue] > 0 ? [bonusInfoData[@"18"] longValue] : self.bonus_threeDiffAll;
    self.bonus_twoSameDouble = [bonusInfoData[@"19"] longValue] > 0 ? [bonusInfoData[@"19"] longValue] : self.bonus_twoSameDouble;
    self.bonus_twoSameSingle = [bonusInfoData[@"20"] longValue] > 0 ? [bonusInfoData[@"20"] longValue] : self.bonus_twoSameSingle;
    self.bonus_twoDiff = [bonusInfoData[@"21"] longValue] > 0 ? [bonusInfoData[@"21"] longValue] : self.bonus_twoDiff;
}
@end
