//
//  CLFTBonusInfo.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/13.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLFTBonusInfo : NSObject

@property (nonatomic, assign) long bonus_sumFour;
@property (nonatomic, assign) long bonus_sumFive;
@property (nonatomic, assign) long bonus_sumSix;
@property (nonatomic, assign) long bonus_sumSeven;
@property (nonatomic, assign) long bonus_sumEight;
@property (nonatomic, assign) long bonus_sumNine;
@property (nonatomic, assign) long bonus_sumTen;
@property (nonatomic, assign) long bonus_sumEleven;
@property (nonatomic, assign) long bonus_sumTwelve;
@property (nonatomic, assign) long bonus_sumThirteen;
@property (nonatomic, assign) long bonus_sumFourteen;
@property (nonatomic, assign) long bonus_sumFifteen;
@property (nonatomic, assign) long bonus_sumSixteen;
@property (nonatomic, assign) long bonus_sumSeventeen;
@property (nonatomic, assign) long bonus_threeSameAll;//三同号通选
@property (nonatomic, assign) long bonus_threeSameSingle;//三同号单选
@property (nonatomic, assign) long bonus_threeDiff;//三不同号
@property (nonatomic, assign) long bonus_threeDiffAll;//三连号通选
@property (nonatomic, assign) long bonus_twoSameDouble;//二同号复选
@property (nonatomic, assign) long bonus_twoSameSingle;//二同号单选
@property (nonatomic, assign) long bonus_twoDiff;//二不同号
/*
"1":80,//和值4
"2":40,//和值5
"3":25,//和值6
"4":16,//和值7
"5":12,//和值8
"6":10,//和值9
"7":9,//和值10
"8":9,//和值11
"9":10,//和值12
"10":12,//和值13
"11":16,//和值14
"12":25,//和值15
"13":40,//和值16
"14":80,//和值17
"15":40,//三同号通选
"16":240, //三同号单选
"17":40, //三不同号
"18":10, //三连号通选
"19":15, //二同号复选
"20":80, //二同号单选
"21":8 //二不同号
*/

/**
 设置奖金信息

 @param bonusInfoData bonusInfo
 */
- (void)setBonusInfoWithData:(NSDictionary *)bonusInfoData;

@end
