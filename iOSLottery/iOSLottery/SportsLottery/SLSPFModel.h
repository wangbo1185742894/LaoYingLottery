//
//  SLSPFModel.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/16.
//  Copyright © 2017年 caiqr. All rights reserved.
//  胜平负模型

#import "SLBaseModel.h"

@class SLSPF_SPModel;

@interface SLSPFModel : SLBaseModel

@property (nonatomic, strong) SLSPF_SPModel *sp;

@property (nonatomic, assign) NSInteger danguan;

@property (nonatomic, strong) SLSPF_SPModel *change;

@property (nonatomic, strong) NSString *handicap;

/**
 是否开售 （自加）
 */
@property (nonatomic, assign) BOOL isSale;
@end


@interface SLSPF_SPModel : SLBaseModel

@property (nonatomic, strong) NSString *win;

@property (nonatomic, strong) NSString *draw;

@property (nonatomic, strong) NSString *loss;

@end
