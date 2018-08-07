//
//  CLLotteryBonusNumModel.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/17.
//  Copyright © 2016年 caiqr. All rights reserved.
//
// 某一期次 是否开奖的model
#import "CLBaseModel.h"

typedef NS_ENUM(NSInteger , CLLotteryAwardStatusType) {
    
    CLLotteryAwardStatusTypeNone = 0, //未开奖
    CLLotteryAwardStatusTypeAward //开奖
};

@interface CLLotteryBonusNumModel : CLBaseModel

@property (nonatomic, strong) NSString *periodId;
@property (nonatomic, strong) NSString *winningNumbers;
@property (nonatomic, strong) NSString *gameName;
@property (nonatomic, strong) NSString *gameEn;
@property (nonatomic, assign) long awardStatus;
@property (nonatomic, strong) id resultMap;

/**
 试机号
 */
@property (nonatomic, strong) NSString *testNum;

/*{
 "resp":[{
 "periodId":"20160926004",
 "winningNumbers":"1 2 3",
 "gameName":"上海快3",
 "gameEn":"shKuai3",
 "awardStatus":1,
 "resultMap":{
 "hezhi":6,
 "awardShape":"三不同号",
 "awardStyle1":"小",
 "awardStyle2":"双"
 }
 },{
 
 "periodId":"20160926004",
 "winningNumbers":null,
 "gameName":"上海快3",
 "gameEn":"shKuai3",
 "awardStatus":0,
 "resultMap":{
 "awardStatusCn":"等待开奖",
 "awardTime":3600
 }
 }],
 "serverTime":"2016-11-04 09:15:21"
 }*/

@end
