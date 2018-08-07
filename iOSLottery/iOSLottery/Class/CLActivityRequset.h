//
//  CLActivityRequset.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/4/5.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLLotteryBusinessRequest.h"

@interface CLActivityRequset : CLLotteryBusinessRequest<CLBaseConfigRequest>

- (void)dealingActivityArrayForDictionary:(id)dict;

- (NSArray *)pullActivityDate;

@end
