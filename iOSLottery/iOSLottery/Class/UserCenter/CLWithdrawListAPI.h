//
//  CLWithdrawListAPI.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/13.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLCaiqrBusinessRequest.h"

@interface CLWithdrawListAPI : CLCaiqrBusinessRequest

- (void) dealingWithDrawDataFromDict:(NSDictionary*) dict;

- (void) updateChannelInfos:(NSArray*)infos;

- (void) updateChannelCardIndex:(NSInteger)index;

- (NSArray *) pullChannelInfos;

//- (NSArray *) pullWithdrawData;

- (NSString*) getChannelType;

- (id) accountData;
- (id) bankCardDataAtIndex:(NSInteger *)index;
@end
