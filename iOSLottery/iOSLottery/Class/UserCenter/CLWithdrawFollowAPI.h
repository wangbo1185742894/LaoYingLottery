//
//  CLWithdrawFollowAPI.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/13.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLCaiqrBusinessRequest.h"

@interface CLWithdrawFollowAPI : CLCaiqrBusinessRequest

- (void)refresh;

- (void)nextPage;

- (void)dealingWithFollowDict:(NSDictionary*)dict;

- (NSArray*)pullFollowData;

- (BOOL)canLoadMore;

@end
