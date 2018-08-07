//
//  CLDEBetDetailDataManager.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/5.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLDEBetDetailDataManager.h"

#import "CLDEBetDetailModel.h"
#import "CLNewLotteryBetInfo.h"
#import "CLLotteryBaseBetTerm.h"
@implementation CLDEBetDetailDataManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSArray <CLDEBetDetailModel *>*)getBetDetailModelWithGameEn:(NSString *)gameEn{
    
    NSArray *deBetTermArray = [[CLNewLotteryBetInfo shareLotteryBetInfo] getBetTermsWithLotteryType:gameEn];
    NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < deBetTermArray.count; i++) {
        
        CLLotteryBaseBetTerm *betTerm = deBetTermArray[deBetTermArray.count - i - 1];
        
        CLDEBetDetailModel *model = [[CLDEBetDetailModel alloc] init];
        model.betNumber = betTerm.betNumber;
        model.betType = [self getBetTypeWithPlayMothedType:betTerm.playMothedType];
        model.betNote = [NSString stringWithFormat:@"%zi注", betTerm.betNote];
        model.betMoney = [NSString stringWithFormat:@"%zi元", betTerm.betNote * 2];
        [modelArray addObject:model];
    }
    return modelArray;
}
- (NSString *)getBetTypeWithPlayMothedType:(CLDElevenPlayMothedType)playMothedType{
    
    switch (playMothedType) {
        case CLDElevenPlayMothedTypeTwo:
            return @"任选二";
            break;
        case CLDElevenPlayMothedTypeThree:
            return @"任选三";
            break;
        case CLDElevenPlayMothedTypeFour:
            return @"任选四";
            break;
        case CLDElevenPlayMothedTypeFive:
            return @"任选五";
            break;
        case CLDElevenPlayMothedTypeSix:
            return @"任选六";
            break;
        case CLDElevenPlayMothedTypeSeven:
            return @"任选七";
            break;
        case CLDElevenPlayMothedTypeEight:
            return @"任选八";
            break;
        case CLDElevenPlayMothedTypePreOne:
            return @"前一";
            break;
        case CLDElevenPlayMothedTypePreTwoDirect:
            return @"前二直选";
            break;
        case CLDElevenPlayMothedTypePreTwoGroup:
            return @"前二组选";
            break;
        case CLDElevenPlayMothedTypePreThreeDirect:
            return @"前三直选";
            break;
        case CLDElevenPlayMothedTypePreThreeGroup:
            return @"前三组选";
            break;
        case CLDElevenPlayMothedTypeDTTwo:
            return @"任选二胆拖";
            break;
        case CLDElevenPlayMothedTypeDTThree:
            return @"任选三胆拖";
            break;
        case CLDElevenPlayMothedTypeDTFour:
            return @"任选四胆拖";
            break;
        case CLDElevenPlayMothedTypeDTFive:
            return @"任选五胆拖";
            break;
        case CLDElevenPlayMothedTypeDTSix:
            return @"任选六胆拖";
            break;
        case CLDElevenPlayMothedTypeDTSeven:
            return @"任选七胆拖";
            break;
        case CLDElevenPlayMothedTypeDTEight:
            return @"任选八胆拖";
            break;
        case CLDElevenPlayMothedTypeDTPreTwoGroup:
            return @"前二组选胆拖";
            break;
        case CLDElevenPlayMothedTypeDTPreThreeGroup:
            return @"前三组选胆拖";
            break;
        default:
            break;
    }
    return @"";
}

@end
