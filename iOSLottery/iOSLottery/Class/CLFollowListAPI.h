//
//  CLFollowListAPI.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLLotteryBusinessRequest.h"

@interface CLFollowListAPI : CLLotteryBusinessRequest

@property (nonatomic, strong) NSString *skipUrl;

@property (nonatomic, strong) NSString *bulletTips;

@property (nonatomic, assign) NSInteger ifSkipDownload;

@property (nonatomic, readonly) BOOL canLoadMore;

- (void)refresh;

- (void)nextPage;

- (BOOL)arrangeListWithAPIData:(NSDictionary*)dict error:(NSError**)error;

- (NSArray*)pullFollowList;

@end
