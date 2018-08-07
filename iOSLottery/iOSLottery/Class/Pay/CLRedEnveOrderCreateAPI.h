//
//  CLRedEnveOrderCreateAPI.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLCaiqrBusinessRequest.h"

@interface CLRedEnveOrderCreateAPI : CLCaiqrBusinessRequest

@property (nonatomic, copy) NSString* amount;
@property (nonatomic, copy) NSString* need_channels;
@property (nonatomic, copy) NSString* trading_infos;
@property (nonatomic, copy) NSString* red_program_id;
@property (nonatomic, copy) NSString* card_no;

@end
