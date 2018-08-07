//
//  SLPlayMethodModel.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/12.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLBaseModel.h"

@interface SLPlayMethodModel : SLBaseModel

/**
 是否是单关
 */
@property (nonatomic, assign) NSInteger danguan;

/**
 让球数
 */
@property (nonatomic, strong) NSString *handicap;

/**
 赔率
 */
@property (nonatomic, strong) NSArray *sp;

/**
 未知参数
 */
@property (nonatomic, strong) NSArray *change;

@end
