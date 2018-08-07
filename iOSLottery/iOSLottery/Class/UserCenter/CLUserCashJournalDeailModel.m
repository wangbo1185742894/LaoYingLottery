//
//  CLUserCashJournalDeailModel.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/25.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLUserCashJournalDeailModel.h"

@implementation CLUserCashJournalDeailModel

- (void)setMemo:(NSString *)memo
{
    _memo = memo;
    if ([memo isKindOfClass:[NSString class]])
    {
        NSString *jsonString = [NSString stringWithFormat:@"%@",memo];
        _memo_array = [jsonString mj_JSONObject];
    }
    else
    {
        _memo_array = @[];
    }
}


@end
