//
//  CLOrderListModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/28.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

@interface CLOrderListModel : CLBaseModel

@property (nonatomic, strong) NSString* gameName;
@property (nonatomic) double orderAmount;
@property (nonatomic, strong) NSString* remark;
@property (nonatomic, strong) NSString* priodId;
@property (nonatomic, strong) NSString *statusCnColor;
@property (nonatomic, assign) BOOL ifSkipDetail;
@property (nonatomic) NSInteger gameId;
@property (nonatomic) NSInteger totalTickets;
@property (nonatomic) NSInteger successTickets;
@property (nonatomic, strong) NSString* createTime;
@property (nonatomic, assign) long long endTime;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic) NSInteger commonFlag;
@property (nonatomic) NSInteger orderStatus;
@property (nonatomic, strong) NSString* orderStatusCn;
@property (nonatomic, strong) NSString* orderType;
@property (nonatomic, strong) NSString* orderTypeCn;
@property (nonatomic) NSInteger prizeStatus;
@property (nonatomic) double  bonus;
@property (nonatomic, strong) NSString *gameIcon;
@property (nonatomic, assign) long long gameType;

@end
