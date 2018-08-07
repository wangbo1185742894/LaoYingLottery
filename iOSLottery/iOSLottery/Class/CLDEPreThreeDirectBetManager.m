//
//  CLDEPreThreeDirectBetManager.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/6.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLDEPreThreeDirectBetManager.h"
#import "CLDEPreThreeDirectBetTerm.h"
#import "CLDEBonusInfo.h"
@implementation CLDEPreThreeDirectBetManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.firstBetTermArray = [NSMutableArray arrayWithCapacity:0];
        self.secondBetTermArray = [NSMutableArray arrayWithCapacity:0];
        self.thirdBetTermArray = [NSMutableArray arrayWithCapacity:0];
        self.bonusInfo = [[CLDEBonusInfo alloc] init];
    }
    return self;
}
#pragma mark ------------ private Mothed ------------
- (BOOL)compareTwoArrayHasSameWithFirstArray:(NSArray *)firstArray secondArray:(NSArray *)secondArray{
    BOOL isSame = NO;
    for (NSString *firstBetTerm in firstArray) {
        for (NSString *secondBetTerm in secondArray) {
            if ([firstBetTerm isEqualToString:secondBetTerm]) {
                isSame = YES;
                break;
            }
        }
    }
    return isSame;
}
#pragma mark ------------ public Mothed ------------
#pragma mark - 投注项的数组
- (NSArray<CLDEPreThreeDirectBetTerm *> *)betTermArray{
    
    if (self.firstBetTermArray.count < 1 || self.secondBetTermArray.count < 1 || self.thirdBetTermArray.count < 1) return nil;

    BOOL isSame1 = [self compareTwoArrayHasSameWithFirstArray:self.firstBetTermArray secondArray:self.secondBetTermArray];
    BOOL isSame2 = [self compareTwoArrayHasSameWithFirstArray:self.secondBetTermArray secondArray:self.thirdBetTermArray];
    BOOL isSame3 = [self compareTwoArrayHasSameWithFirstArray:self.firstBetTermArray secondArray:self.thirdBetTermArray];
    if (isSame1 || isSame2 || isSame3) {
        return [self hasSameTerm];
    }else{
        return [self noHasSameTerm];
    }
}
#pragma mark - 返回投注的注数
- (NSInteger)betNote{
    
    NSInteger note = 0;
    for (CLDEPreThreeDirectBetTerm *betTerm in self.betTermArray) {
        note += betTerm.betNote;
    }
    return note;
}
#pragma mark - 最小奖金
- (NSInteger)minBetBonus{
    
    return self.betNote > 0 ? self.bonusInfo.bonus_de_preThreeDirect : 0;
}
#pragma mark - 最大奖金
- (NSInteger)MaxBetBonus{
    
    return self.betNote > 0 ? self.bonusInfo.bonus_de_preThreeDirect : 0;
}
#pragma mark ------------ private Mothed ------------
- (NSArray <CLDEPreThreeDirectBetTerm *> *)hasSameTerm{
    
    NSMutableArray *betArray = [NSMutableArray arrayWithCapacity:0];
    for (NSString *firstBetTerm in self.firstBetTermArray) {
        for (NSString *secondBetTerm in self.secondBetTermArray) {
            for (NSString *thirdBetTerm in self.thirdBetTermArray) {
                if (!([firstBetTerm isEqualToString:secondBetTerm] || [firstBetTerm isEqualToString:thirdBetTerm] || [secondBetTerm isEqualToString:thirdBetTerm])) {
                    CLDEPreThreeDirectBetTerm *betTerm = [[CLDEPreThreeDirectBetTerm alloc] init];
                    betTerm.bonusInfo = self.bonusInfo;
                    [betTerm.firstBetTermArray addObject:firstBetTerm];
                    [betTerm.secondBetTermArray addObject:secondBetTerm];
                    [betTerm.thirdBetTermArray addObject:thirdBetTerm];
                    [betArray addObject:betTerm];
                }
            }
        }
    }
    return betArray;
}
- (NSArray <CLDEPreThreeDirectBetTerm *> *)noHasSameTerm{
    
    CLDEPreThreeDirectBetTerm *betTerm = [[CLDEPreThreeDirectBetTerm alloc] init];
    betTerm.bonusInfo = self.bonusInfo;
    [betTerm.firstBetTermArray addObjectsFromArray:self.firstBetTermArray];
    [betTerm.secondBetTermArray addObjectsFromArray:self.secondBetTermArray];
    [betTerm.thirdBetTermArray addObjectsFromArray:self.thirdBetTermArray];
    return @[betTerm];
}

@end
