//
//  SLNewBetSelectInfo.h
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/25.
//  Copyright © 2017年 caiqr. All rights reserved.
// 暂未使用   目的 ： 想修改用户选项存储单例  将object改为字典 省去for遍历

#import <Foundation/Foundation.h>

@interface SLNewBetSelectInfo : NSObject

/**
 投注内容 key ： matchIssue  value ：dic
 */
@property (nonatomic, strong) NSMutableDictionary *betSelectInfo;

/**
 选择的串关选项
 */
@property (nonatomic, strong) NSMutableArray *chuanGuanArray;

/**
 投注倍数
 */
@property (nonatomic, assign) NSInteger betMultiple;


@end
