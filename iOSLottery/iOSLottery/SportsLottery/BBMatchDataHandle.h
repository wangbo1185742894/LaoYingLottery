//
//  BBMatchDataHandle.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//  篮球数据处理类

#import <Foundation/Foundation.h>

@interface BBMatchDataHandle : NSObject

/**
 处理请求数据
 */
- (void)disposeDataWithArray:(NSArray *)array;

- (NSArray *)getDataArray;

@end
