//
//  CLOrderTicketAPI.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/27.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLLotteryBusinessRequest.h"

@interface CLOrderTicketAPI : CLLotteryBusinessRequest

@property (nonatomic, strong) NSString* orderId;

- (void)dealingwithTicketForDict:(NSDictionary*)dict;

- (NSArray*)pullData;

@end
