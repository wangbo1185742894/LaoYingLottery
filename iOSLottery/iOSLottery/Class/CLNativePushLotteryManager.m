//
//  CLNativePushLotteryManager.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/4/20.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLNativePushLotteryManager.h"
#import "CLNewLotteryBetInfo.h"
#import "CLSSQNormalBetTerm.h"
#import "CLDLTNormalBetTerm.h"

@implementation CLNativePushLotteryManager

+ (BOOL)saveBetTermInfo:(NSDictionary *)betInfo{
    
    
    
    if (betInfo[@"gameEn"] && [betInfo[@"gameEn"] hasSuffix:@"ssq"]) {
     
        //解析投注号码
        NSString *betNumber = betInfo[@"betNumber"];
        NSArray *betNumbers = [betNumber componentsSeparatedByString:@","];
        if (betNumbers && betNumbers.count > 0) {
            for (NSString *oneBetNumber in betNumbers) {
                return [self createSSQBetTermWithNumber:oneBetNumber gameEn:betInfo[@"gameEn"]];
            }
        }
    }else if ([betInfo[@"gameEn"] hasSuffix:@"dlt"]){
        
        //解析投注号码
        NSString *betNumber = betInfo[@"betNumber"];
        NSArray *betNumbers = [betNumber componentsSeparatedByString:@","];
        if (betNumbers && betNumbers.count > 0) {
            for (NSString *oneBetNumber in betNumbers) {
                return [self createDLTBetTermWithNumber:oneBetNumber gameEn:betInfo[@"gameEn"]];
            }
        }
    }
    return NO;
}

+ (BOOL)createSSQBetTermWithNumber:(NSString *)betNumber gameEn:(NSString *)gameEn{
    
    if (betNumber && betNumber.length > 0) {
        //以":"分隔
        NSArray *redBlue = [betNumber componentsSeparatedByString:@":"];
        if (redBlue && redBlue.count == 2) {
            
            NSString *red = redBlue[0];
            NSString *blue = redBlue[1];
            //解析投注号码
            if (red && red.length > 0 && blue && blue.length > 0) {
                
                NSArray *redNumberArray = [red componentsSeparatedByString:@" "];
                NSArray *blueNumberArray = [blue componentsSeparatedByString:@" "];
                if (redNumberArray && redNumberArray.count == 6 && blueNumberArray && blueNumberArray.count == 1) {
                    
                    //检验投注号码是否正确
                    BOOL checkNumber = YES;
                    for (NSString *singleBetNumber in redNumberArray) {
                        checkNumber = (([singleBetNumber integerValue] < 34) && ([singleBetNumber integerValue] > 0));
                    }
                    checkNumber = (([blueNumberArray[0] integerValue] < 17) && ([blueNumberArray[0] integerValue] > 0));
                    
                    if (checkNumber) {
                        //投注号码 验证成功
                        CLSSQNormalBetTerm *betTerm = [[CLSSQNormalBetTerm alloc] init];
                        [betTerm.redArray addObjectsFromArray:redNumberArray];
                        [betTerm.blueArray addObjectsFromArray:blueNumberArray];
                        [[CLNewLotteryBetInfo shareLotteryBetInfo] addLotteryBetTerm:@[betTerm] lotteryType:gameEn];
                        return YES;
                    }
                }
            }
        }
    }
    return NO;
}
+ (BOOL)createDLTBetTermWithNumber:(NSString *)betNumber gameEn:(NSString *)gameEn{
    
    if (betNumber && betNumber.length > 0) {
        //以":"分隔
        NSArray *redBlue = [betNumber componentsSeparatedByString:@":"];
        if (redBlue && redBlue.count == 2) {
            
            NSString *red = redBlue[0];
            NSString *blue = redBlue[1];
            //解析投注号码
            if (red && red.length > 0 && blue && blue.length > 0) {
                
                NSArray *redNumberArray = [red componentsSeparatedByString:@" "];
                NSArray *blueNumberArray = [blue componentsSeparatedByString:@" "];
                if (redNumberArray && redNumberArray.count == 5 && blueNumberArray && blueNumberArray.count == 2) {
                    
                    //检验投注号码是否正确
                    BOOL checkNumber = YES;
                    for (NSString *singleBetNumber in redNumberArray) {
                        checkNumber = (([singleBetNumber integerValue] < 36) && ([singleBetNumber integerValue] > 0));
                    }
                    for (NSString *singleBetNumber in blueNumberArray) {
                        checkNumber = (([singleBetNumber integerValue] < 13) && ([singleBetNumber integerValue] > 0));
                    }
                    if (checkNumber) {
                        //投注号码 验证成功
                        CLDLTNormalBetTerm *betTerm = [[CLDLTNormalBetTerm alloc] init];
                        [betTerm.redArray addObjectsFromArray:redNumberArray];
                        [betTerm.blueArray addObjectsFromArray:blueNumberArray];
                        [[CLNewLotteryBetInfo shareLotteryBetInfo] addLotteryBetTerm:@[betTerm] lotteryType:gameEn];
                        return YES;
                    }
                }
            }
        }
    }
    return NO;
}

@end
