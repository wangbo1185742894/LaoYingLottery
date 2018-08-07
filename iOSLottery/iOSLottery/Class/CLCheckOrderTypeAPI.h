//
//  CLCheckOrderTypeAPI.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/26.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLLotteryBusinessRequest.h"

typedef NS_ENUM(NSInteger, OrderType) {
    OrderTypeNormal = 1,
    OrderTypeFollow = 2,
};

@interface CLCheckOrderTypeAPI : CLLotteryBusinessRequest

@property (nonatomic, strong) NSString* orderId;

@property (nonatomic, strong) NSString *skipUrl;

@property (nonatomic, strong) NSString *bulletTips;

@property (nonatomic, assign) NSInteger ifSkipDownload;

@property (nonatomic, assign) NSInteger gameType;

- (OrderType) orderTypeForDict:(NSDictionary*)dict;

@end
