//
//  SLJPSModel.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/17.
//  Copyright © 2017年 caiqr. All rights reserved.
//  进球数模型

#import "SLBaseModel.h"

@class SLJPS_SPModel;

@interface SLJPSModel : SLBaseModel

/**
 玩法标题
 */
@property (nonatomic, strong) NSString *playName;

@property (nonatomic, assign) NSInteger danguan;

@property (nonatomic, strong) SLJPS_SPModel *sp;

/**
 是否开售 （自加）
 */
@property (nonatomic, assign) BOOL isSale;
@end

@interface SLJPS_SPModel : SLBaseModel

@property (nonatomic, strong) NSString *sp_0;

@property (nonatomic, strong) NSString *sp_1;

@property (nonatomic, strong) NSString *sp_2;

@property (nonatomic, strong) NSString *sp_3;

@property (nonatomic, strong) NSString *sp_4;

@property (nonatomic, strong) NSString *sp_5;

@property (nonatomic, strong) NSString *sp_6;

@property (nonatomic, strong) NSString *sp_7;

@end
