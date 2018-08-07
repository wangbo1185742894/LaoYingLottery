//
//  SLBetDetailDataManager.m
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/22.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLBetDetailDataManager.h"
#import "SLBetInfoManager.h"
#import "SLBetInfoCache.h"
#import "SLBetDetailsModel.h"
#import "SLMatchBetModel.h"
#import "SLChuanGuanModel.h"
@implementation SLBetDetailDataManager

static bool inbetDetailsVC = nil;

+ (NSArray *)getBetInfo{
    
    NSMutableArray *matchsArray = [NSMutableArray arrayWithCapacity:0];
    for (SLBetSelectSingleGameInfo *singleGameInfo in [SLBetInfoCache shareBetInfoCache].allSelectBetItem.betSelectInfo) {
        
        SLBetDetailsModel *matchModel = [[SLBetDetailsModel alloc] init];
        for (SLMatchBetGroupModel *groupModel in [SLBetInfoCache shareBetInfoCache].allMatchsArray) {
            
            for (SLMatchBetModel *saveMatchModel in groupModel.matches) {
                if ([saveMatchModel.match_issue isEqualToString:singleGameInfo.matchIssue]) {
                    matchModel.hostName = saveMatchModel.host_name;
                    matchModel.awayName = saveMatchModel.away_name;
                    matchModel.matchIssue = saveMatchModel.match_issue;
                    matchModel.matchSession = [NSString stringWithFormat:@"%@%@", saveMatchModel.match_week, saveMatchModel.match_sn];
                }
            }
        }
        for (SLBetSelectPlayMothedInfo *playMothedInfo in singleGameInfo.singleBetSelectArray) {
            
            SLBetDetailsItemModel *model = [[SLBetDetailsItemModel alloc] init];
            model.playName = self.playMothedDic[playMothedInfo.playMothed];
            if ([playMothedInfo.playMothed isEqualToString:RQSPF]) {
                model.playName = [NSString stringWithFormat:@"%@%@", self.playMothedDic[playMothedInfo.playMothed] , playMothedInfo.rangQiuCount];
            }
            for (NSString *selectStr in playMothedInfo.selectPlayMothedArray) {
                [model.betArray addObject:self.playMothedDic[selectStr]];
            }
            if (model.betArray.count > 0) {
                [matchModel.itemArray addObject:model];
            }
        }
        if (matchModel.itemArray.count > 0) {
            [matchsArray addObject:matchModel];
        }
    };
    
    //根据赛事编号排序
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"matchIssue" ascending:YES];
    
    matchsArray = [NSMutableArray arrayWithArray:[matchsArray sortedArrayUsingDescriptors:@[sortDescriptor]]];
    
    return matchsArray;
}

+ (NSArray *)getChuanGuan{

    return [SLBetInfoManager getChuanGuanArray];
}

+ (NSInteger)getNote{
    
    return [SLBetInfoManager getNote];
}

+ (NSInteger)getMultiple{
    
    return [SLBetInfoCache shareBetInfoCache].allSelectBetItem.betMultiple;
}

+ (NSString *)getExpectedBonus{
    
    return [SLBetInfoManager getEstimateBonus];
    
}

+ (NSString *)getAllOddsString
{
        
        NSString *lotteryNumber = @"";
        NSString *singleGameSelectNumber = @"";

        for (SLBetSelectSingleGameInfo *singleGameInfo in [SLBetInfoCache shareBetInfoCache].allSelectBetItem.betSelectInfo) {
            
            
            SLMatchBetModel *matchModel = [SLBetInfoManager getMatchInfoWithIssue:singleGameInfo.matchIssue];
            
            //每一个玩法的投注项
            for (SLBetSelectPlayMothedInfo *playMothedInfo in singleGameInfo.singleBetSelectArray) {
                
                //获取每一个玩法编号
                for (NSString *number in playMothedInfo.selectPlayMothedArray) {
                    
                    //获取每个玩法的赔率
                    NSString *oddsStr = [NSString stringWithFormat:@"%.02f",[matchModel getOddsWithTag:number]];
                    
                    //如果是让球胜平负则需要拼接让球数
                    if ([number integerValue] == 10003  | [number integerValue] == 10001 | [number integerValue] == 10000) {
                        
                        oddsStr = [oddsStr stringByAppendingFormat:@"~%@",playMothedInfo.rangQiuCount];
                    }
                    
                    //拼接投注项和赔率
                    NSString *tempStr = [NSString stringWithFormat:@"%@:%@#",number,oddsStr];
                    
                    singleGameSelectNumber = [singleGameSelectNumber stringByAppendingString:tempStr];
                }
            }
            
            //在没有比赛时，防止奔溃
            if (singleGameSelectNumber.length > 0){
            
                //去除多余的#号
                singleGameSelectNumber = [singleGameSelectNumber substringToIndex:singleGameSelectNumber.length - 1];
            }
                    
            //每场比赛之间空格分割
            singleGameSelectNumber = [singleGameSelectNumber stringByAppendingString:@" "];
            
        }
    
    //去除两端多余空格
    singleGameSelectNumber = [singleGameSelectNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //拼接串关数
    lotteryNumber = [NSString stringWithFormat:@"%@@%@",singleGameSelectNumber,[SLBetInfoManager getCreateOrderChuanGuan]];
    
    //快速点击导致的异常情况
    if ([lotteryNumber containsString:@"0_1"]) return @"";
    
    return lotteryNumber.length > 0 ? lotteryNumber : @"";
}


+ (BOOL)isShowToast
{
    
    if (inbetDetailsVC && [SLBetInfoManager getHasAllDanGuan] && [self getBetInfo].count == 1) {
        
        return YES;
    }
    return NO;
}

+ (void)setInBetDetailsVC:(BOOL)inBetDetailsVC
{
    inbetDetailsVC = inBetDetailsVC;
}

+ (BOOL)inBetDetailsVC
{
    return inbetDetailsVC;
}


+ (NSDictionary *)playMothedDic{
    
    return @{SPF : @"胜平负",
             RQSPF : @"让球胜平负",
             ZJQ : @"总进球",
             BQC : @"半全场",
             BF : @"比分",
             @"3" : @"主胜",
             @"1" : @"平",
             @"0" : @"主负",
             @"10003" : @"主胜",
             @"10001" : @"平",
             @"10000" : @"主负",
             @"1033" : @"胜胜",
             @"1031" : @"胜平",
             @"1030" : @"胜负",
             @"1013" : @"平胜",
             @"1011" : @"平平",
             @"1010" : @"平负",
             @"1003" : @"负胜",
             @"1001" : @"负平",
             @"1000" : @"负负",
             @"100" : @"0",
             @"101" : @"1",
             @"102" : @"2",
             @"103" : @"3",
             @"104" : @"4",
             @"105" : @"5",
             @"106" : @"6",
             @"107" : @"7+",
             @"10" : @"1:0",
             @"20" : @"2:0",
             @"21" : @"2:1",
             @"30" : @"3:0",
             @"31" : @"3:1",
             @"32" : @"3:2",
             @"40" : @"4:0",
             @"41" : @"4:1",
             @"42" : @"4:2",
             @"50" : @"5:0",
             @"51" : @"5:1",
             @"52" : @"5:2",
             @"90" : @"胜其他",
             @"00" : @"0:0",
             @"11" : @"1:1",
             @"22" : @"2:2",
             @"33" : @"3:3",
             @"99" : @"平其他",
             @"01" : @"0:1",
             @"02" : @"0:2",
             @"12" : @"1:2",
             @"03" : @"0:3",
             @"13" : @"1:3",
             @"23" : @"2:3",
             @"04" : @"0:4",
             @"14" : @"1:4",
             @"24" : @"2:4",
             @"05" : @"0:5",
             @"15" : @"1:5",
             @"25" : @"2:5",
             @"09" : @"负其他"};
}

@end

