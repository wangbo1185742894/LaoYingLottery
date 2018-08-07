//
//  CLBetLimitRequestTool.h
//  iOSLottery
//
//  Created by 洪利 on 2018/6/30.
//  Copyright © 2018年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>

#define bet_limit_tool [CLBetLimitRequestTool sharedInstance]

@interface CLBetLimitRequestTool : NSObject
@property (nonatomic, assign) NSInteger timerCounting;
+ (instancetype)sharedInstance;
@property (nonatomic, copy) void (^ betlimitCallBack)(BOOL state);
- (void)startCheckBetLimit;

@end
