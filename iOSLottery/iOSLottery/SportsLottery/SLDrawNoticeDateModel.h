//
//  SLDrawNoticeDateModel.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/6/1.
//  Copyright © 2017年 caiqr. All rights reserved.
//  开奖公告日期模型

#import "SLBaseModel.h"

@interface SLDrawNoticeDateModel : SLBaseModel


@property (nonatomic, strong) NSString *titleName;

@property (nonatomic, strong) NSArray *daysArray;

+ (SLDrawNoticeDateModel *)drawNoticeDateModelWith:(NSString *)str;

@end
