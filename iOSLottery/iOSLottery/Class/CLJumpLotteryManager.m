//
//  CLJumpLotteryManager.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/22.
//  Copyright © 2016年 caiqr. All rights reserved.
//
//统一 跳转 彩种的管理类

#import "CLJumpLotteryManager.h"
//彩种投注项
#import "CLNewLotteryBetInfo.h"
//统跳
#import "CLAllJumpManager.h"

#import "CLATBetCache.h"

@interface CLJumpLotteryManager ()


@end

@implementation CLJumpLotteryManager

+(void)jumpLotteryWithGameEn:(NSString *)lotteryGameEn{
    
    [self jumpLotteryWithGameEn:lotteryGameEn isJudgeCache:YES];
}

+ (void)jumpLotteryWithGameEn:(NSString *)lotteryGameEn isJudgeCache:(BOOL)isJudgeCache{
    
    
    if ([[lotteryGameEn lowercaseString] hasSuffix:@"d11"]) {
        //跳转 D11
        if ([[CLNewLotteryBetInfo shareLotteryBetInfo] getAllNoteWithLottery:lotteryGameEn] > 0 && isJudgeCache) {
            //如果有投注项  跳转投注详情
            [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLDEBetDetailViewController_push/%@", lotteryGameEn]];
        }else{
            [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLDElevenViewController_present/%@", lotteryGameEn]];
        }
    } else if ([[lotteryGameEn lowercaseString] hasSuffix:@"kuai3"]) {
        //跳转快3
        if ([[CLNewLotteryBetInfo shareLotteryBetInfo] getAllNoteWithLottery:lotteryGameEn] > 0  && isJudgeCache) {
            
            [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLFTBetDetailViewController_push/%@", lotteryGameEn]];
        }else{
            [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLFastThreeViewController_present/%@", lotteryGameEn]];
        }

    }else if ([[lotteryGameEn lowercaseString] hasSuffix:@"ssq"]) {
        //双色球
        if ([[CLNewLotteryBetInfo shareLotteryBetInfo] getAllNoteWithLottery:lotteryGameEn] > 0  && isJudgeCache) {
            
            [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLSSQBetDetailViewController_push/%@", lotteryGameEn]];
        }else{
            [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLSSQViewController_present/%@", lotteryGameEn]];
        }
    }else if ([[lotteryGameEn lowercaseString] hasSuffix:@"dlt"]) {
        //跳转dlt
        if ([[CLNewLotteryBetInfo shareLotteryBetInfo] getAllNoteWithLottery:lotteryGameEn] > 0  && isJudgeCache) {
            
            [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLDLTDetailViewController_push/%@", lotteryGameEn]];
        }else{
            [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLDLTViewController_present/%@", lotteryGameEn]];
        }
    }else if ([[lotteryGameEn lowercaseString] hasSuffix:@"jczq_mix_p"]){
        
        [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"SLListViewController_present"]];
    }else if ([[lotteryGameEn lowercaseString] hasSuffix:@"jclq_mix_p"]){
        
        [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"BBMatchBetListController_present"]];
        
        
    }else if ([[lotteryGameEn lowercaseString] hasSuffix:@"pl3"] || [[lotteryGameEn lowercaseString] hasSuffix:@"fc3d"]){
        
        if ([[CLATBetCache shareCache] getBetOptionsCacheWithLotteryName:lotteryGameEn] .count > 0 && isJudgeCache) {
            
            [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLATBetDetailsViewController_push/%@",lotteryGameEn]];
            
        }else{
        
            [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLArrangeThreeViewController_present/%@",lotteryGameEn]];
        }
    }else if ([[lotteryGameEn lowercaseString] hasSuffix:@"pl5"]){
    
        if ([[CLATBetCache shareCache] getBetOptionsCacheWithLotteryName:lotteryGameEn] .count > 0 && isJudgeCache) {
            
            [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLATBetDetailsViewController_push/%@",lotteryGameEn]];
            
        }else{
            
            [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLArrangeFiveViewController_present/%@",lotteryGameEn]];
        }
    }else if ([[lotteryGameEn lowercaseString] hasPrefix:@"qlc"]){
        
        if ([[CLATBetCache shareCache] getBetOptionsCacheWithLotteryName:lotteryGameEn].count > 0 && isJudgeCache) {
            
            [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLATBetDetailsViewController_push/%@",lotteryGameEn]];
            
        }else{
            [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLQLCViewController_present/%@",lotteryGameEn]];
        }
    }else if ([[lotteryGameEn lowercaseString] hasPrefix:@"qxc"]){
        
        if ([[CLATBetCache shareCache] getBetOptionsCacheWithLotteryName:lotteryGameEn].count > 0 && isJudgeCache) {
            
            [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLATBetDetailsViewController_push/%@",lotteryGameEn]];
            
        }else{
        
            [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLQXCViewController_present/%@",lotteryGameEn]];
         }
    }else if ([[lotteryGameEn lowercaseString] hasPrefix:@"sfc"] || [[lotteryGameEn lowercaseString] hasPrefix:@"rx9"]){
    
        [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLSFCViewController_present/%@",lotteryGameEn]];
    }
}

+ (void)jumpLotteryDestoryWithGameEn:(NSString *)lotteryGameEn{
    
    [self jumpLotteryDestoryWithGameEn:lotteryGameEn isJudgeCache:NO];
}
+ (void)jumpLotteryDestoryWithGameEn:(NSString *)lotteryGameEn isJudgeCache:(BOOL)isJudgeCache{
    
    
    if ([[lotteryGameEn lowercaseString] hasSuffix:@"d11"]) {
        //跳转 D11
        if ([[CLNewLotteryBetInfo shareLotteryBetInfo] getAllNoteWithLottery:lotteryGameEn] > 0 && isJudgeCache) {
            //如果有投注项  跳转投注详情
            [[CLAllJumpManager shareAllJumpManager] openDestoryWithURL:[NSString stringWithFormat:@"CLDEBetDetailViewController_push/%@", lotteryGameEn]];
        }else{
            [[CLAllJumpManager shareAllJumpManager] openDestoryWithURL:[NSString stringWithFormat:@"CLDElevenViewController_present/%@", lotteryGameEn]];
        }
    } else if ([[lotteryGameEn lowercaseString] hasSuffix:@"kuai3"]) {
        //跳转快3
        if ([[CLNewLotteryBetInfo shareLotteryBetInfo] getAllNoteWithLottery:lotteryGameEn] > 0  && isJudgeCache) {
            
            [[CLAllJumpManager shareAllJumpManager] openDestoryWithURL:[NSString stringWithFormat:@"CLFTBetDetailViewController_push/%@", lotteryGameEn]];
        }else{
            [[CLAllJumpManager shareAllJumpManager] openDestoryWithURL:[NSString stringWithFormat:@"CLFastThreeViewController_present/%@", lotteryGameEn]];
        }
    }else if ([[lotteryGameEn lowercaseString] hasSuffix:@"ssq"]) {
        //跳转ssq
        if ([[CLNewLotteryBetInfo shareLotteryBetInfo] getAllNoteWithLottery:lotteryGameEn] > 0  && isJudgeCache) {
            
            [[CLAllJumpManager shareAllJumpManager] openDestoryWithURL:[NSString stringWithFormat:@"CLSSQBetDetailViewController_push/%@", lotteryGameEn]];
        }else{
            [[CLAllJumpManager shareAllJumpManager] openDestoryWithURL:[NSString stringWithFormat:@"CLSSQViewController_present/%@", lotteryGameEn]];
        }
    }else if ([[lotteryGameEn lowercaseString] hasSuffix:@"dlt"]) {
        //跳转快3
        if ([[CLNewLotteryBetInfo shareLotteryBetInfo] getAllNoteWithLottery:lotteryGameEn] > 0  && isJudgeCache) {
            
            [[CLAllJumpManager shareAllJumpManager] openDestoryWithURL:[NSString stringWithFormat:@"CLDLTDetailViewController_push/%@", lotteryGameEn]];
        }else{
            [[CLAllJumpManager shareAllJumpManager] openDestoryWithURL:[NSString stringWithFormat:@"CLDLTViewController_present/%@", lotteryGameEn]];
        }
    }else if ([[lotteryGameEn lowercaseString] hasSuffix:@"jczq_mix_p"]){
        
        [[CLAllJumpManager shareAllJumpManager] openDestoryWithURL:[NSString stringWithFormat:@"SLListViewController_present"]];
    }else if ([[lotteryGameEn lowercaseString] hasSuffix:@"jclq_mix_p"]){
        
        [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"BBMatchBetListController_present"]];
    }
}

+ (void)jumpLotteryWithGameEn:(NSString *)lotteryGameEn playMothed:(NSString *)playMothed{
    
    
    if ([[lotteryGameEn lowercaseString] hasSuffix:@"d11"]) {
        //跳转 D11
        [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLDElevenViewController_present/%@/%@", lotteryGameEn,playMothed]];
    } else if ([[lotteryGameEn lowercaseString] hasSuffix:@"kuai3"]) {
        //跳转快3
        [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLFastThreeViewController_present/%@/%@", lotteryGameEn, playMothed]];
        
    }else if ([[lotteryGameEn lowercaseString] hasSuffix:@"ssq"]) {
        //双色球
        [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLSSQViewController_present/%@/%@", lotteryGameEn, playMothed]];
    }else if ([[lotteryGameEn lowercaseString] hasSuffix:@"dlt"]) {
        //跳转dlt
        [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLDLTViewController_present/%@/%@", lotteryGameEn, playMothed]];
    }else if ([[lotteryGameEn lowercaseString] hasSuffix:@"jczq_mix_p"]){
        //跳转竞彩足球投注
        [[CLAllJumpManager shareAllJumpManager] openDestoryWithURL:[NSString stringWithFormat:@"SLListViewController_present"]];
    }else if ([[lotteryGameEn lowercaseString] hasSuffix:@"jclq_mix_p"]){
        
        [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"BBMatchBetListController_present"]];
    }
        
}
@end
