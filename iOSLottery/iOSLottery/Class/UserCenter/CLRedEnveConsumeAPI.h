//
//  CLRedEnveConsumeAPI.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/29.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLCaiqrBusinessRequest.h"

@interface CLRedEnveConsumeAPI : CLCaiqrBusinessRequest

@property (nonatomic, strong) NSString* user_fid;

@property (nonatomic) BOOL canLoadMore;

- (void) refresh;

- (void) nextPage;

- (void) configureConsumeFollowDataWithArr:(NSArray*)arr;

- (NSArray*) pullData;

@end
