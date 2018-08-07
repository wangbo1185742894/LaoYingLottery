//
//  CQCashDepositPaySource.h
//  caiqr
//
//  Created by 彩球 on 16/7/4.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CQPaymentBaseSource.h"

@interface CQCashDepositPaySource : CQPaymentBaseSource

@property (nonatomic, strong) NSArray* pay_trading_info;

@property (nonatomic, strong) NSString* order_id;

@end
