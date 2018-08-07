//
//  CLBuyRedEnveListAPI.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/12.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLCaiqrBusinessRequest.h"

@interface CLBuyRedEnveListAPI : CLCaiqrBusinessRequest

- (NSArray*) channelList;

- (NSString*) redCustomProgramId;

- (NSArray*) redBuylist;

- (NSString *)calculateCustomRedAmountWithSourc:(NSString *)sourceAmount;

- (void)dealingWithRedEnvelopListFromDict:(NSDictionary *)dict;

@end
