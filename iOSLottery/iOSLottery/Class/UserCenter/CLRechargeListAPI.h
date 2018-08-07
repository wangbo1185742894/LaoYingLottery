//
//  CLRechargeListAPI.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLCaiqrBusinessRequest.h"



@interface CLRechargeListAPI : CLCaiqrBusinessRequest

- (void)dealingWithRechargeData:(NSDictionary*)dict;
- (NSMutableArray*) pullChannel;
- (NSArray*) pullFillList;
- (NSString *) pullTemplate;
- (NSArray *) pullBigMoney;
@end
