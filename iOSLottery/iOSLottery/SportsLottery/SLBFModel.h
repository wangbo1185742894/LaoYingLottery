//
//  SLBiFenModel.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/17.
//  Copyright © 2017年 caiqr. All rights reserved.
//  比分模型

#import "SLBaseModel.h"

@class SLBF_SPModel;

@interface SLBFModel : SLBaseModel
/**
 玩法标题
 */
@property (nonatomic, strong) NSString *playName;

@property (nonatomic, assign) NSInteger danguan;

@property (nonatomic, strong) SLBF_SPModel *sp;

/**
 是否开售 （自加）
 */
@property (nonatomic, assign) BOOL isSale;

@end

@interface SLBF_SPModel : SLBaseModel

@property (nonatomic, strong) NSString *sp_1_0;

@property (nonatomic, strong) NSString *sp_2_0;

@property (nonatomic, strong) NSString *sp_2_1;

@property (nonatomic, strong) NSString *sp_3_0;

@property (nonatomic, strong) NSString *sp_3_1;

@property (nonatomic, strong) NSString *sp_3_2;

@property (nonatomic, strong) NSString *sp_4_0;

@property (nonatomic, strong) NSString *sp_4_1;

@property (nonatomic, strong) NSString *sp_4_2;

@property (nonatomic, strong) NSString *sp_5_0;

@property (nonatomic, strong) NSString *sp_5_1;

@property (nonatomic, strong) NSString *sp_5_2;
/**
 胜其他
 */
@property (nonatomic, strong) NSString *sp_9_0;

@property (nonatomic, strong) NSString *sp_0_0;

@property (nonatomic, strong) NSString *sp_1_1;

@property (nonatomic, strong) NSString *sp_2_2;

@property (nonatomic, strong) NSString *sp_3_3;
/**
 平其他
 */
@property (nonatomic, strong) NSString *sp_9_9;

@property (nonatomic, strong) NSString *sp_0_1;

@property (nonatomic, strong) NSString *sp_0_2;

@property (nonatomic, strong) NSString *sp_1_2;

@property (nonatomic, strong) NSString *sp_0_3;

@property (nonatomic, strong) NSString *sp_1_3;

@property (nonatomic, strong) NSString *sp_2_3;

@property (nonatomic, strong) NSString *sp_0_4;

@property (nonatomic, strong) NSString *sp_1_4;

@property (nonatomic, strong) NSString *sp_2_4;

@property (nonatomic, strong) NSString *sp_0_5;

@property (nonatomic, strong) NSString *sp_1_5;

@property (nonatomic, strong) NSString *sp_2_5;
/**
 负其他
 */
@property (nonatomic, strong) NSString *sp_0_9;



@end
