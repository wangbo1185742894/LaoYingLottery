//
//  CLSFCBetModel.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/26.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

@interface CLSFCBetModel : CLBaseModel

@property (nonatomic, strong) NSString *awayName;
@property (nonatomic, strong) NSString *awayRank;
@property (nonatomic, strong) NSString *awayRecentRecord;

@property (nonatomic, strong) NSString *historyRecentRecord;

@property (nonatomic, strong) NSString *hostName;
@property (nonatomic, strong) NSString *hostRank;
@property (nonatomic, strong) NSString *hostRecentRecord;

@property (nonatomic, strong) NSString *league;
@property (nonatomic, strong) NSString *matchDay;
@property (nonatomic, strong) NSString *matchId;
@property (nonatomic, strong) NSString *matchStartTime;

@property (nonatomic, strong) NSString *odds;
@property (nonatomic, strong) NSString *result;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *serialNumber;

@property (nonatomic, strong) NSString *betOption;
@property (nonatomic, strong) NSArray *betOptionArr;

/**
 预测底层页跳转链接
 */
@property (nonatomic, strong) NSString *sfcBottomPageUrl;

/**
 是否显示历史详情
 */
@property (nonatomic, assign, getter = isShowHistory) BOOL showHistory;

@end
