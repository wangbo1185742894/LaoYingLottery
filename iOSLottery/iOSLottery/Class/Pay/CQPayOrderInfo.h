//
//  CQPayOrderInfo.h
//  caiqr
//
//  Created by 彩球 on 16/4/5.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CLBaseModel.h"

@interface CQPayOrderInfo : CLBaseModel

@property (nonatomic, strong) NSString* order_id;
@property (nonatomic, strong) NSString* user_id;
@property (nonatomic, assign) NSInteger order_type;
@property (nonatomic, assign) long long amount;
@property (nonatomic, assign) NSInteger order_status;

@end


@interface CQPayToken : CLBaseModel

@property (nonatomic, strong) NSString* pay_for_token;
@property (nonatomic, strong) NSString* pay_for_channel;
@property (nonatomic, strong) NSString* flow_id;

@end


@interface CQRechagreInfo : CLBaseModel

@property (nonatomic, strong) NSArray* pay_for_tokens;
@property (nonatomic, strong) CQPayOrderInfo* order_info;

@end

