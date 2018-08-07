//
//  SLMatchHistoryModel.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/12.
//  Copyright © 2017年 caiqr. All rights reserved.
//  历史战绩模型

#import "SLBaseModel.h"

@interface SLMatchHistoryModel : SLBaseModel

@property (nonatomic, assign) NSInteger win;

@property (nonatomic, assign) NSInteger draw;

@property (nonatomic, assign) NSInteger loss;

@end
