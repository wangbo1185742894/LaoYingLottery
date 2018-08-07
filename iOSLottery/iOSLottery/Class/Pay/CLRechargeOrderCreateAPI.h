//
//  CLRechargeOrderCreateAPI.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLCaiqrBusinessRequest.h"

@interface CLRechargeOrderCreateAPI : CLCaiqrBusinessRequest

@property (nonatomic, strong) NSString* amount;
@property (nonatomic, strong) NSString* need_channels;
@property (nonatomic, strong) NSString* trading_infos;
@property (nonatomic, strong) NSString* card_no;

@end
