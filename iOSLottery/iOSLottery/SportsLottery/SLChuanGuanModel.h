//
//  SLChuanGuanModel.h
//  SportsLottery
//
//  Created by huangyuchen on 2017/6/3.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLChuanGuanModel : NSObject

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
