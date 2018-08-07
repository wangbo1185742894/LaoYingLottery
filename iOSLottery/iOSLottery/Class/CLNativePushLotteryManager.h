//
//  CLNativePushLotteryManager.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/4/20.
//  Copyright © 2017年 caiqr. All rights reserved.
// 外部跳转客户端投注详情页时 对数据做处理

#import <Foundation/Foundation.h>

@interface CLNativePushLotteryManager : NSObject

+ (BOOL)saveBetTermInfo:(NSDictionary *)betInfo;

@end
