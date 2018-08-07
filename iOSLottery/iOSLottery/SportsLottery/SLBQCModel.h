//
//  SLBQCModel.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/17.
//  Copyright © 2017年 caiqr. All rights reserved.
//  半全场模型

#import "SLBaseModel.h"

@class SLBQC_SPModel;

@interface SLBQCModel : SLBaseModel

/**
 玩法标题
 */
@property (nonatomic, strong) NSString *playName;

@property (nonatomic, strong) SLBQC_SPModel *sp;

@property (nonatomic, assign) NSInteger danguan;

/**
 是否开售 （自加）
 */
@property (nonatomic, assign) BOOL isSale;

@end

@interface SLBQC_SPModel : SLBaseModel

/**
 胜胜
 */
@property (nonatomic, strong) NSString *sp_3_3;

/**
 胜平
 */
@property (nonatomic, strong) NSString *sp_3_1;

/**
 胜负
 */
@property (nonatomic, strong) NSString *sp_3_0;

/**
 胜负
 */
@property (nonatomic, strong) NSString *sp_1_3;

/**
 平平
 */
@property (nonatomic, strong) NSString *sp_1_1;

/**
 平负
 */
@property (nonatomic, strong) NSString *sp_1_0;

/**
 负胜
 */
@property (nonatomic, strong) NSString *sp_0_3;

/**
 负平
 */
@property (nonatomic, strong) NSString *sp_0_1;

/**
 负负
 */
@property (nonatomic, strong) NSString *sp_0_0;

@end
