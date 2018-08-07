//
//  CLHomeViewHandler.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/10.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLHomeViewHandler.h"
#import "CLHomeAPIModel.h"
#import "CLHomeGamePeriodModel.h"
#import "CLHomeModuleModel.h"
#import "CLHomeHotBetModel.h"

@interface CLHomeViewHandler ()

@property (nonatomic, strong) CLHomeGamePeriodModel* gamePeriod;
@property (nonatomic, strong) CLHomeAPIModel* apiResult;
@property (nonatomic, strong) NSMutableArray* homeListData;

/**
 当前版本支持的彩种数组 （v1.2 HYC add）
 */
@property (nonatomic, strong) NSArray *isSupportArray;

@end

@implementation CLHomeViewHandler

/* 焦点图 */
- (NSArray*) banners {
    
    return self.apiResult.banners;
}

/* 跑马灯 */
- (NSArray*) reports {
    
    return self.apiResult.reports;
}


/* 列表UI */
- (NSArray*) homeData {
    
    return self.homeListData;
}


- (void) homeDataDealingWithDict:(NSDictionary*)dict {
    
    CLHomeAPIModel* apiResult = [CLHomeAPIModel mj_objectWithKeyValues:dict];
    if (!apiResult) return;
    if (self.apiResult) self.apiResult = nil;
    [self.homeListData removeAllObjects];
    self.apiResult = apiResult;
    
    if (self.apiResult.hotGamePeriods && ((NSArray *)self.apiResult.hotGamePeriods) > 0) {
        CLHomeModuleModel* hotPeriod = [[CLHomeModuleModel alloc] init];
        hotPeriod.style = HomeModuleStyleQuickBet;
        hotPeriod.moduleObjc = self.apiResult.hotGamePeriods;
        if (self.apiResult.hotGamePeriods.count > 0) {
            
            CLHomeGamePeriodModel *periodModel = ((CLHomeHotBetModel *)self.apiResult.hotGamePeriods[0]).periodVo;
            if (periodModel && ![periodModel isKindOfClass:[NSNull class]]) {
                
                for (NSString *gameSuf in self.isSupportArray) {
                    
                    if ([periodModel.gameEn hasSuffix:gameSuf]) {
                        [self.homeListData addObject:hotPeriod];
                    }
                }
                
            }
        }
    }
   
    if (self.apiResult.gameEntrances && ((NSArray *)self.apiResult.gameEntrances) > 0){
        CLHomeModuleModel* gameEnModel = [[CLHomeModuleModel alloc] init];
        gameEnModel.style = HomeModuleStyleMargin;
        gameEnModel.title = apiResult.gamesEntranceCn;
        gameEnModel.moduleObjc = apiResult.gamesEntranceCn;
        [self.homeListData addObject:gameEnModel];
        CLHomeModuleModel* lottery = [[CLHomeModuleModel alloc] init];
        lottery.style = HomeModuleStyleLottery;
        lottery.title = apiResult.gamesEntranceCn;
        lottery.moduleObjc = self.apiResult.gameEntrances;
        [self.homeListData addObject:lottery];
    }
    
    if (apiResult.attentionEntrances && ((NSArray *)apiResult.attentionEntrances) > 0){
        CLHomeModuleModel* focusTitleModel = [[CLHomeModuleModel alloc] init];
        focusTitleModel.style = HomeModuleStyleMargin;
        focusTitleModel.title = apiResult.attentionEntranceCn;
        focusTitleModel.moduleObjc = apiResult.attentionEntranceCn;
        [self.homeListData addObject:focusTitleModel];
        CLHomeModuleModel* focus = [[CLHomeModuleModel alloc] init];
        focus.style = HomeModuleStyleFocus;
        focus.title = apiResult.attentionEntranceCn;
        focus.moduleObjc = apiResult.attentionEntrances;
        [self.homeListData addObject:focus];
    }
}

- (void) periodDealingWithDict:(NSDictionary*)dict {
    
    CLHomeGamePeriodModel* gamePeriod = [CLHomeGamePeriodModel mj_objectWithKeyValues:dict];
    
    CLHomeModuleModel* hotPeriod = [[CLHomeModuleModel alloc] init];
    hotPeriod.style = HomeModuleStyleQuickBet;
    hotPeriod.moduleObjc = gamePeriod;
    
    [self.homeListData replaceObjectAtIndex:0 withObject:hotPeriod];
}


- (NSMutableArray *)homeListData {
    
    if (!_homeListData) {
        _homeListData = [NSMutableArray new];
    }
    return _homeListData;
}

- (NSArray *)isSupportArray{
    
    return @[@"kuai3",@"d11",@"ssq",@"dlt"];
}
@end
