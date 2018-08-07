//
//  CLPreTwoDirectBetManager.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/6.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLPreTwoDirectBetManager.h"
#import "CLDETwoGroupBetTerm.h"
#import "CLDEBonusInfo.h"
@implementation CLPreTwoDirectBetManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.firstBetTermArray = [NSMutableArray arrayWithCapacity:0];
        self.secondBetTermArray = [NSMutableArray arrayWithCapacity:0];
        self.bonusInfo = [[CLDEBonusInfo alloc] init];
    }
    return self;
}
#pragma mark ------------ public Mothed ------------
#pragma mark - 投注项的数组
- (NSArray<CLDETwoGroupBetTerm *> *)betTermArray{
    
    if (self.firstBetTermArray.count < 1 || self.secondBetTermArray.count < 1) return nil;
    BOOL isSame = NO;
    for (NSString *firstBetTerm in self.firstBetTermArray) {
        for (NSString *secondBetTerm in self.secondBetTermArray) {
            if ([firstBetTerm isEqualToString:secondBetTerm]) {
                isSame = YES;
                break;
            }
        }
    }
    if (isSame) {
        if (self.firstBetTermArray.count == 1 && self.secondBetTermArray.count == 1) return nil;
        return [self hasSameTerm];
    }else{
        return [self noHasSameTerm];
    }
}
#pragma mark - 返回投注的注数
- (NSInteger)betNote{
    
    NSInteger note = 0;
    for (CLDETwoGroupBetTerm *betTerm in self.betTermArray) {
        note += betTerm.betNote;
    }
    return note;
}
#pragma mark - 最小奖金
- (NSInteger)minBetBonus{
    
    return self.betNote > 0 ? self.bonusInfo.bonus_de_preTwoDirect : 0;
}
#pragma mark - 最大奖金
- (NSInteger)MaxBetBonus{
    
    return self.betNote > 0 ? self.bonusInfo.bonus_de_preTwoDirect : 0;
}
#pragma mark ------------ private Mothed ------------
- (NSArray <CLDETwoGroupBetTerm *> *)hasSameTerm{
    
    NSMutableArray *betArray = [NSMutableArray arrayWithCapacity:0];
    for (NSString *firstBetTerm in self.firstBetTermArray) {
        for (NSString *secondBetTerm in self.secondBetTermArray) {
            if (![firstBetTerm isEqualToString:secondBetTerm]) {
                CLDETwoGroupBetTerm *betTerm = [[CLDETwoGroupBetTerm alloc] init];
                betTerm.bonusInfo = self.bonusInfo;
                [betTerm.firstBetTermArray addObject:firstBetTerm];
                [betTerm.secondBetTermArray addObject:secondBetTerm];
                [betArray addObject:betTerm];
            }
        }
    }
    return betArray;
}
- (NSArray <CLDETwoGroupBetTerm *> *)noHasSameTerm{
    
    CLDETwoGroupBetTerm *betTerm = [[CLDETwoGroupBetTerm alloc] init];
    betTerm.bonusInfo = self.bonusInfo;
    [betTerm.firstBetTermArray addObjectsFromArray:self.firstBetTermArray];
    [betTerm.secondBetTermArray addObjectsFromArray:self.secondBetTermArray];
    return @[betTerm];
}
@end
