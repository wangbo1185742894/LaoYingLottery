//
//  CQLotteryPaySource.h
//  caiqr
//
//  Created by 彩球 on 16/7/4.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CKPaymentBaseSource.h"

@interface CKLotteryPaySource : CKPaymentBaseSource

@property (nonatomic, readwrite) BOOL has_redPacket;
@property (nonatomic, strong) NSString* redPa_amount;
@property (nonatomic, strong) NSString* redPa_program_id;
@property (nonatomic, strong) NSString* order_id;

@end
