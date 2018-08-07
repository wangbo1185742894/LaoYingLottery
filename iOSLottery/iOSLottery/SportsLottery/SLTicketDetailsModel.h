//
//  CLTicketDetailsModel.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/4/22.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLBaseModel.h"

@interface SLTicketDetailsModel : SLBaseModel

/**
 玩法中文名
 */
@property (nonatomic, strong) NSString *extraCn;

@property (nonatomic, strong) NSArray *ticketVos;

@end

@interface SLTicketDetailsItemModel : SLBaseModel

/**
 订单ID
 */
@property (nonatomic, strong) NSString *orderId;

/**
 票ID
 */
@property (nonatomic, strong) NSString *ticketId;

/**
 投注倍数
 */
@property (nonatomic, assign) NSInteger times;

/**
 票状态
 */
@property (nonatomic, assign) NSInteger ticketStatus;

/**
 票状态中文
 */
@property (nonatomic, strong) NSString *ticketStatusCn;

/**
 中奖状态
 */
@property (nonatomic, assign) NSInteger prizeStatus;

/**
 票状态中文色值
 */
@property (nonatomic, strong) NSString *statusColor;

/**
 投注项
 */
@property (nonatomic, strong) NSArray *lotteryNumbers;


@end
