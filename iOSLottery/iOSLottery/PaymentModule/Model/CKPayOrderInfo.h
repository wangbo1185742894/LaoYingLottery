//
//  CQPayOrderInfo.h
//  caiqr
//
//  Created by 彩球 on 16/4/5.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKCommonPaymentConf.h"
@interface CKPayOrderInfo : NSObject

@property (nonatomic, strong) NSString* order_id;
@property (nonatomic, strong) NSString* user_id;
@property (nonatomic, assign) NSInteger order_type;
@property (nonatomic, assign) long long amount;
@property (nonatomic, assign) NSInteger order_status;

@end


@interface CKPayToken : NSObject

@property (nonatomic, strong) NSString* pay_for_token;
@property (nonatomic, strong) NSString* pay_for_channel;
@property (nonatomic, strong) NSString* flow_id;

@end


@interface CKRechagreInfo : NSObject

@property (nonatomic, strong) NSArray* pay_for_tokens;
@property (nonatomic, assign) CKWXPaymentChannelType pay_channel_key;
@property (nonatomic, strong) CKPayOrderInfo* order_info;

@end

