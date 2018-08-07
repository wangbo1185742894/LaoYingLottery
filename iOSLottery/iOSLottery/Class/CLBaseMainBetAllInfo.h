//
//  CLBaseMainBetAllInfo.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/22.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLotteryMainBetModel;

@interface CLBaseMainBetAllInfo : NSObject
/*
 彩种
 */
//网络请求的数据
@property (nonatomic, strong) CLLotteryMainBetModel* mainResquestData;
//上次记录的玩法
@property (nonatomic, assign) NSInteger lastRecordPlayMothed;
/**
 是否显示遗漏
 */
@property (nonatomic, assign, getter=isOmission) BOOL omission;

@end
