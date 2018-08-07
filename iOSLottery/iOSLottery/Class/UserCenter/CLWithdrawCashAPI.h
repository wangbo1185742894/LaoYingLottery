//
//  CLWithdrawCashAPI.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLCaiqrBusinessRequest.h"

@interface CLWithdrawCashAPI : CLCaiqrBusinessRequest

@property (nonatomic, strong) NSString* amount;
@property (nonatomic, strong) NSString* channel_type;
@property (nonatomic, strong) NSDictionary* channel_info;

@end
