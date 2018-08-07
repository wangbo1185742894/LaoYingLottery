//
//  BBBetDetailsInfoManager.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/14.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBBetDetailsInfoManager.h"

#import "BBMatchInfoManager.h"
#import "BBSeletedGameModel.h"

#import "SLBetDetailsModel.h"
#import "BBMatchGroupModel.h"
#import "BBMatchModel.h"
#import "BBDXFModel.h"


@implementation BBBetDetailsInfoManager

+ (NSArray *)getBetInfo{
    
    NSMutableArray *matchsArray = [NSMutableArray arrayWithCapacity:0];
    
    
    NSArray *selectedMatchArray = [[[BBMatchInfoManager shareManager] getSelectMatchInfo] allValues];
    
    for (BBSeletedGameModel *singleGameInfo in selectedMatchArray) {
       
        BBMatchModel *tempMatchModel;
        
        SLBetDetailsModel *matchModel = [[SLBetDetailsModel alloc] init];
        
        for (BBMatchGroupModel *groupModel in [[BBMatchInfoManager shareManager] getAllMatchArray]) {
            
            for (BBMatchModel *saveMatchModel in groupModel.matches) {
                
                if ([saveMatchModel.match_issue isEqualToString:singleGameInfo.matchIssue]) {
                    
                    matchModel.hostName = saveMatchModel.away_name;
                    matchModel.awayName = saveMatchModel.host_name;
                    matchModel.matchIssue = saveMatchModel.match_issue;
                    matchModel.matchSession = [NSString stringWithFormat:@"%@%@", saveMatchModel.match_week, saveMatchModel.match_sn];
                    
                    tempMatchModel = saveMatchModel;
                }
            }
        }
        
        
        if (singleGameInfo.sfInfo.playMothed != nil) {
           
            SLBetDetailsItemModel *model = [[SLBetDetailsItemModel alloc] init];
            
            model.playName = self.playMethodDic[singleGameInfo.sfInfo.playMothed];
            NSArray *betResult = [singleGameInfo.sfInfo.selectPlayMothedArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 compare:obj2]; //升序
            }];
            for (NSString *selectStr in betResult) {
                [model.betArray addObject:self.playMethodDic[selectStr]];
            }
            
            if (model.betArray.count > 0) {
                
                [matchModel.itemArray addObject:model];
            }
        }
        
        
        
        if (singleGameInfo.rfsfInfo.playMothed != nil) {
            
            SLBetDetailsItemModel *model = [[SLBetDetailsItemModel alloc] init];
            
            model.playName = [NSString stringWithFormat:@"%@%@",self.playMethodDic[singleGameInfo.rfsfInfo.playMothed],singleGameInfo.rfsfInfo.rangFenCount];
            NSArray *betResult = [singleGameInfo.rfsfInfo.selectPlayMothedArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 compare:obj2]; //升序
            }];
            for (NSString *selectStr in betResult) {
                [model.betArray addObject:self.playMethodDic[selectStr]];
            }
            
            if (model.betArray.count > 0) {
                
                [matchModel.itemArray addObject:model];
            }
        }
        
        
        if (singleGameInfo.dxfInfo.playMothed != nil) {
            
            SLBetDetailsItemModel *model = [[SLBetDetailsItemModel alloc] init];
            
            model.playName = self.playMethodDic[singleGameInfo.dxfInfo.playMothed];
            NSArray *betResult = [singleGameInfo.dxfInfo.selectPlayMothedArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 compare:obj2]; //升序
            }];
            for (NSString *selectStr in betResult) {
                [model.betArray addObject:[NSString stringWithFormat:@"%@%@",self.playMethodDic[selectStr],tempMatchModel.dxf.odds]];
            }
            
            if (model.betArray.count > 0) {
                
                [matchModel.itemArray addObject:model];
            }
        }
        
        
        if (singleGameInfo.sfcInfo.playMothed != nil) {
            
            SLBetDetailsItemModel *model = [[SLBetDetailsItemModel alloc] init];
            
            model.playName = self.playMethodDic[singleGameInfo.sfcInfo.playMothed];
            NSArray *betResult = [singleGameInfo.sfcInfo.selectPlayMothedArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 compare:obj2]; //升序
            }];
            for (NSString *selectStr in betResult) {
                [model.betArray addObject:self.playMethodDic[selectStr]];
            }
            
            if (model.betArray.count > 0) {
                
                [matchModel.itemArray addObject:model];
            }
        }
        
        if (matchModel.itemArray.count > 0) {
            [matchsArray addObject:matchModel];
        }
    }
    
    //根据赛事编号排序
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"matchIssue" ascending:YES];
    
    matchsArray = [NSMutableArray arrayWithArray:[matchsArray sortedArrayUsingDescriptors:@[sortDescriptor]]];
    
    return matchsArray;
    
}

+ (NSArray *)getChuanGuan
{
    
    return [[BBMatchInfoManager shareManager] getChuanGuanArray];
}

+ (NSInteger)getNote{
    
    return [[BBMatchInfoManager shareManager] getNote];
}

+ (NSInteger)getMultiple{
    
    return [[BBMatchInfoManager shareManager] getMultiple];
}

+ (NSInteger)getDefaultMultiple{
    
    return [[BBMatchInfoManager shareManager] getDefaultMultiple];
}

+ (NSString *)getExpectedBonus
{
    
    return [[BBMatchInfoManager shareManager] getEstimateBonus];
    
}

//+ (NSString *)getAllOddsString
//{
//    
//    NSString *lotteryNumber = @"";
//    NSString *singleGameSelectNumber = @"";
//    
//    for (SLBetSelectSingleGameInfo *singleGameInfo in [SLBetInfoCache shareBetInfoCache].allSelectBetItem.betSelectInfo) {
//        
//        
//        SLMatchBetModel *matchModel = [SLBetInfoManager getMatchInfoWithIssue:singleGameInfo.matchIssue];
//        
//        //每一个玩法的投注项
//        for (SLBetSelectPlayMothedInfo *playMothedInfo in singleGameInfo.singleBetSelectArray) {
//            
//            //获取每一个玩法编号
//            for (NSString *number in playMothedInfo.selectPlayMothedArray) {
//                
//                //获取每个玩法的赔率
//                NSString *oddsStr = [NSString stringWithFormat:@"%.02f",[matchModel getOddsWithTag:number]];
//                
//                //如果是让球胜平负则需要拼接让球数
//                if ([number integerValue] == 10003  | [number integerValue] == 10001 | [number integerValue] == 10000) {
//                    
//                    oddsStr = [oddsStr stringByAppendingFormat:@"~%@",playMothedInfo.rangQiuCount];
//                }
//                
//                //拼接投注项和赔率
//                NSString *tempStr = [NSString stringWithFormat:@"%@:%@#",number,oddsStr];
//                
//                singleGameSelectNumber = [singleGameSelectNumber stringByAppendingString:tempStr];
//            }
//        }
//        
//        //在没有比赛时，防止奔溃
//        if (singleGameSelectNumber.length > 0){
//            
//            //去除多余的#号
//            singleGameSelectNumber = [singleGameSelectNumber substringToIndex:singleGameSelectNumber.length - 1];
//        }
//        
//        //每场比赛之间空格分割
//        singleGameSelectNumber = [singleGameSelectNumber stringByAppendingString:@" "];
//        
//    }
//    
//    //去除两端多余空格
//    singleGameSelectNumber = [singleGameSelectNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    
//    //拼接串关数
//    lotteryNumber = [NSString stringWithFormat:@"%@@%@",singleGameSelectNumber,[SLBetInfoManager getCreateOrderChuanGuan]];
//    
//    //快速点击导致的异常情况
//    if ([lotteryNumber containsString:@"0_1"]) return @"";
//    
//    return lotteryNumber.length > 0 ? lotteryNumber : @"";
//}


+ (BOOL)isShowToast
{
    
    if ( [[BBMatchInfoManager shareManager] getHasAllDanGuan] && [self getBetInfo].count == 1) {
        
        return YES;
    }
    return NO;
}


+ (NSDictionary *)playMethodDic{
    
    return @{@"sf": @"胜负",
             @"rfsf" : @"让分",
             @"dxf" : @"大小分",
             @"sfc" : @"胜分差",
             
             @"3" : @"主胜",
             @"0" : @"主负",
             
             @"1003" : @"让主胜",
             @"1000" : @"让主负",
             @"102" : @"大于",
             @"101" : @"小于",
             
             @"31" : @"主胜1-5",
             @"32" : @"主胜6-10",
             @"33" : @"主胜11-15",
             @"34" : @"主胜16-20",
             @"35" : @"主胜21-25",
             @"36" : @"主胜26+",
             
             @"01" : @"主负1-5",
             @"02" : @"主负6-10",
             @"03" : @"主负11-15",
             @"04" : @"主负16-20",
             @"05" : @"主负21-25",
             @"06" : @"主负26+"};
}


@end
