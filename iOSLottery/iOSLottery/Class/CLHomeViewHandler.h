//
//  CLHomeViewHandler.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/10.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLHomeViewHandler : NSObject

/* 焦点图 */
- (NSArray*) banners;

/* 跑马灯 */
- (NSArray*) reports;

/* 列表UI */
- (NSArray*) homeData;

- (void) homeDataDealingWithDict:(NSDictionary*)dict;

- (void) periodDealingWithDict:(NSDictionary*)dict;


@end
