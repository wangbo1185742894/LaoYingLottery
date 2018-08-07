//
//  CLPersonalJournalModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/25.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"
#import "CLAccountInfoModel.h"

@class CLPersonalJournalCashLog;

@interface CLPersonalJournalModel : CLBaseModel

@property (nonatomic, strong) CLAccountInfoModel* account_info;

@property (nonatomic, strong) CLPersonalJournalCashLog* cash_log;

@end

@interface CLPersonalJournalCashLog : CLBaseModel

@property (nonatomic, strong) NSString* get_last_day;
@property (nonatomic, strong) NSMutableArray* result_list;

@end

