//
//  CLDETwoGroupBetTerm.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/6.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLDETwoGroupBetTerm.h"
#import "CLDEBonusInfo.h"
@implementation CLDETwoGroupBetTerm

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.firstBetTermArray = [NSMutableArray arrayWithCapacity:0];
        self.secondBetTermArray = [NSMutableArray arrayWithCapacity:0];
        self.playMothedType = CLDElevenPlayMothedTypePreTwoDirect;
    }
    return self;
}
#pragma mark ------------ private Mothed ------------

#pragma mark ------------ getter Mothed ------------
#pragma mark - 返回投注号码 （用于投注详情展示）
- (NSString *)betNumber{
    
    [CLTools sortSequenceWithArray:self.firstBetTermArray];
    [CLTools sortSequenceWithArray:self.secondBetTermArray];

    NSString *firstStr = [self.firstBetTermArray componentsJoinedByString:@" "];
    NSString *secondStr = [self.secondBetTermArray componentsJoinedByString:@" "];
    return [NSString stringWithFormat:@"%@|%@", firstStr, secondStr];
}
#pragma mark - 返回投注的注数
- (NSInteger)betNote{
    
    return self.firstBetTermArray.count * self.secondBetTermArray.count;
}
#pragma mark - 最小奖金
- (NSInteger)minBetBonus{
    
    return self.betNote > 0 ? self.bonusInfo.bonus_de_preTwoDirect : 0;
}
#pragma mark - 最大奖金
- (NSInteger)MaxBetBonus{
    
    return self.betNote > 0 ? self.bonusInfo.bonus_de_preTwoDirect : 0;
}
#pragma mark - 获取创建订单时的字符串
- (NSString *)orderBetNumber{
    
    [CLTools sortSequenceWithArray:self.firstBetTermArray];
    [CLTools sortSequenceWithArray:self.secondBetTermArray];
    NSString *firstStr = [self.firstBetTermArray componentsJoinedByString:@" "];
    NSString *secondStr = [self.secondBetTermArray componentsJoinedByString:@" "];
    return self.betNote ? [NSString stringWithFormat:@"%@|%@%@", firstStr, secondStr, de_order_preTwoDirect] : @"";
}

@end
