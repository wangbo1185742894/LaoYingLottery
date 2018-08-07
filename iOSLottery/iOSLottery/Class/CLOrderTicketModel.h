//
//  CLOrderTicketModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/27.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

@interface CLOrderTicketModel : CLBaseModel

@property (nonatomic, strong) NSString* extraCn;
@property (nonatomic, strong) NSArray* ticketVos;

@end


@interface CLTicketVo : CLBaseModel

@property (nonatomic, strong) NSString* orderId;
@property (nonatomic, strong) NSString* ticketId;
@property (nonatomic) double bonus;
@property (nonatomic, strong) NSString* ticketNo;
@property (nonatomic) NSInteger times;
@property (nonatomic, strong) NSArray* lotteryNumbers;
@property (nonatomic, strong) NSString* ticketStatusCn;
@property (nonatomic, assign) NSInteger prizeStatus;

@end
