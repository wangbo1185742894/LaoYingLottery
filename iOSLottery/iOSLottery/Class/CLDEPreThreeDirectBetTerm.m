//
//  CLDEPreThreeDirectBetTerm.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/6.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLDEPreThreeDirectBetTerm.h"
#import "CLDEBonusInfo.h"
@implementation CLDEPreThreeDirectBetTerm

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.firstBetTermArray = [NSMutableArray arrayWithCapacity:0];
        self.secondBetTermArray = [NSMutableArray arrayWithCapacity:0];
        self.thirdBetTermArray = [NSMutableArray arrayWithCapacity:0];
        self.playMothedType = CLDElevenPlayMothedTypePreThreeDirect;
    }
    return self;
}
#pragma mark ------------ getter Mothed ------------
#pragma mark - 返回投注号码 （用于投注详情展示）
- (NSString *)betNumber{
    
    [CLTools sortSequenceWithArray:self.firstBetTermArray];
    [CLTools sortSequenceWithArray:self.secondBetTermArray];
    [CLTools sortSequenceWithArray:self.thirdBetTermArray];
    NSString *firstStr = [self.firstBetTermArray componentsJoinedByString:@" "];
    NSString *secondStr = [self.secondBetTermArray componentsJoinedByString:@" "];
    NSString *thirdStr = [self.thirdBetTermArray componentsJoinedByString:@" "];
    return [NSString stringWithFormat:@"%@|%@|%@", firstStr, secondStr, thirdStr];
}
#pragma mark - 返回投注的注数
- (NSInteger)betNote{
    
    return self.firstBetTermArray.count * self.secondBetTermArray.count * self.thirdBetTermArray.count;
}
#pragma mark - 最小奖金
- (NSInteger)minBetBonus{
    
    return self.betNote > 0 ? self.bonusInfo.bonus_de_preThreeDirect : 0;
}
#pragma mark - 最大奖金
- (NSInteger)MaxBetBonus{
    
    return self.betNote > 0 ? self.bonusInfo.bonus_de_preThreeDirect : 0;
}
#pragma mark - 获取创建订单时的字符串
- (NSString *)orderBetNumber{
    
    [CLTools sortSequenceWithArray:self.firstBetTermArray];
    [CLTools sortSequenceWithArray:self.secondBetTermArray];
    [CLTools sortSequenceWithArray:self.thirdBetTermArray];
    NSString *firstStr = [self.firstBetTermArray componentsJoinedByString:@" "];
    NSString *secondStr = [self.secondBetTermArray componentsJoinedByString:@" "];
    NSString *thirdStr = [self.thirdBetTermArray componentsJoinedByString:@" "];
    return self.betNote ? [NSString stringWithFormat:@"%@|%@|%@%@", firstStr, secondStr, thirdStr, de_order_preThreeDirect] : @"";
}
@end
