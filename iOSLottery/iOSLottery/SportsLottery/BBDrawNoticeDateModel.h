//
//  BBDrawNoticeDateModel.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/11.
//  Copyright © 2017年 caiqr. All rights reserved.
//  篮球开奖公告 日期模型

#import "SLBaseModel.h"

@interface BBDrawNoticeDateModel : SLBaseModel

@property (nonatomic, strong) NSString *titleName;

@property (nonatomic, strong) NSArray *daysArray;

+ (instancetype)drawNoticeDateModelWith:(NSString *)str;

@end
