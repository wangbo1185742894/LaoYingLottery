//
//  CLRequestTimeLimitService.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/20.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLRequestTimeLimitService : NSObject

/**
 最大请求时间限制
 */
@property (nonatomic, assign) NSInteger maxRequestTimeLimit;


/**
 请求时间限制

 @return 返回yes 表示可以请求
 */
- (BOOL)requestTimeLimit;

@end
