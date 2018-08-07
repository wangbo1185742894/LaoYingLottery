//
//  SLTicketDetailsRequest.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/6/7.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLLotteryBusinessRequest.h"

@class SLTicketDetailsItemModel;

@interface SLTicketDetailsRequest : CLLotteryBusinessRequest<CLBaseConfigRequest>

@property (nonatomic, strong) NSString *order_id;

/**
 处理请求数据
 */
- (void)disposeDataWithArray:(NSArray *)data;

- (NSArray *)getDataArray;

- (NSInteger)getDataArrayCount;

- (SLTicketDetailsItemModel *)getTicketModelAtIndex:(NSInteger)index;

@end
