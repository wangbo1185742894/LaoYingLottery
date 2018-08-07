//
//  CLSSQDetailDataManager.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/7.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLSSQDetailDataManager.h"
#import "CLSSQDetailModel.h"
#import "CLNewLotteryBetInfo.h"
#import "CLLotteryBaseBetTerm.h"
#import "CLSSQConfigMessage.h"
@implementation CLSSQDetailDataManager

- (NSArray <CLSSQDetailModel *>*)getBetDetailModelWithGameEn:(NSString *)gameEn{
    
    NSArray *deBetTermArray = [[CLNewLotteryBetInfo shareLotteryBetInfo] getBetTermsWithLotteryType:gameEn];
    NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < deBetTermArray.count; i++) {
        
        CLLotteryBaseBetTerm *betTerm = deBetTermArray[deBetTermArray.count - i - 1];
        
        CLSSQDetailModel *model = [[CLSSQDetailModel alloc] init];
        model.betNumber = betTerm.betNumber;
        if (betTerm.playMothedType == CLSSQPlayMothedTypeNormal) {
            
            model.betType = betTerm.betNote > 1 ? @"复式" : @"单式";
        }else{
            model.betType = @"胆拖";
        }
        
        model.betNote = [NSString stringWithFormat:@"%zi注", betTerm.betNote];
        model.betMoney = [NSString stringWithFormat:@"%zi元", betTerm.betNote * 2];
        [modelArray addObject:model];
    }
    return modelArray;
}

@end
