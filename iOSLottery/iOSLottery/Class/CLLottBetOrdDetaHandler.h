//
//  CLLottBetOrdDetaHandler.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

/** 订单详情数据处理 */

#import <Foundation/Foundation.h>

@interface CLLottBetOrdDetaHandler : NSObject

- (NSString*)orderId;

- (id)dealingWithOrderDetaViewData:(NSDictionary*)dict lotteryCodeAdapter:(id)lottAdapter;

@end
