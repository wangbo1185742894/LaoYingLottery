//
//  CQRedPacketPaySource.h
//  caiqr
//
//  Created by 彩球 on 16/7/4.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CKPaymentBaseSource.h"

@interface CKRedPacketPaySource : CKPaymentBaseSource

@property (nonatomic, strong) NSString* redPaProgramId;

@property (nonatomic, strong) NSArray* redPaTradingInfo;

@property (nonatomic, strong) NSString* orderId;

@property (nonatomic, strong) NSString *card_no;

@end
