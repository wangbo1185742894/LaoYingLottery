//
//  CLAccountJournalAPI.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/25.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLCaiqrBusinessRequest.h"

@class CLPersonalJournalCashLog,CLAccountInfoModel;

@interface CLAccountJournalAPI : CLCaiqrBusinessRequest

@property (nonatomic, strong) NSString* last_day;

- (void)refresh;

- (void)nextPage;

- (BOOL)isCanLoadMore;

- (void) updateJournalListArrayWith:(NSDictionary*)objc;

- (CLAccountInfoModel*) accountInfo;

- (NSMutableArray*) cashLog;

@end
