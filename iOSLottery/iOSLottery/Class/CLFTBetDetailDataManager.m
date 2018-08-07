//
//  CLFTBetDetailDataManager.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/22.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFTBetDetailDataManager.h"
#import "CLFTBetDetailModel.h"
#import "CLNewLotteryBetInfo.h"
#import "CLLotteryBaseBetTerm.h"
@implementation CLFTBetDetailDataManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSArray <CLFTBetDetailModel *>*)getBetDetailModelWithGameEn:(NSString *)lotteryGameEn{
    
    NSArray *fastThreeBetTermArray = [[CLNewLotteryBetInfo shareLotteryBetInfo] getBetTermsWithLotteryType:lotteryGameEn];
    NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:0];
    for (CLLotteryBaseBetTerm *info in fastThreeBetTermArray) {
        
        CLFTBetDetailModel *model = [[CLFTBetDetailModel alloc] init];
        model.betNumber = info.betNumber;
        model.betType = [self getBetTypeWithPlayMothedType:info.betType];
        model.betNote = [NSString stringWithFormat:@"%zi注", info.betNote];
        model.betMoney = [NSString stringWithFormat:@"%zi元", info.betNote * 2];
        [modelArray addObject:model];
    }
    return modelArray;
}
- (NSString *)getBetTypeWithPlayMothedType:(CLFTBetType)playMothedType{
    
    switch (playMothedType) {
        case CLFTBetTypeHeZhi:
            return @"和值";
            break;
        case CLFTBetTypeThreeSameSingle:
            return @"三同号单选";
            break;
        case CLFTBetTypeThreeSameAll:
            return @"三同号通选";
            break;
        case CLFTBetTypeTwoSameSingle:
            return @"二同号单选";
            break;
        case CLFTBetTypeTwoSameDouble:
            return @"二同号复选";
            break;
        case CLFTBetTypeThreeDifferent:
            return @"三不同号";
            break;
        case CLFTBetTypeThreeDifferentContinuous:
            return @"三连号通选";
            break;
        case CLFTBetTypeTwoDifferent:
            return @"二不同号";
            break;
        case CLFTBetTypeDanTuoThreeDifferent:
            return @"三不同号胆拖";
            break;
        case CLFTBetTypeDanTuoTwoDifferent:
            return @"二不同号胆拖";
            break;
        default:
            break;
    }
    return nil;
}
@end
