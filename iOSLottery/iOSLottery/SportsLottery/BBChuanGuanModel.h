//
//  BBChuanGuanModel.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/16.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLBaseModel.h"

@interface BBChuanGuanModel : SLBaseModel

/**
 串关名称
 */
@property (nonatomic, strong) NSString *chuanGuanTitle;

/**
 是否选中
 */
@property (nonatomic, assign) BOOL isSelect;


/**
 代表的串关
 */
@property (nonatomic, strong) NSString *chuanGuanTag;

@end
