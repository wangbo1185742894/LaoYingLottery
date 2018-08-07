//
//  CLRechargeListAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLRechargeListAPI.h"
#import "CLAppContext.h"
#import "CLRechargeModel.h"
#import "CLPaymentChannelInfo.h"

@interface CLRechargeListAPI () <CLBaseConfigRequest>

@property (nonatomic, strong) CLRechargeModel* rechargeData;

@end

@implementation CLRechargeListAPI

- (NSString *)methodName {
    
    return @"get_fill_constant_list";
}

- (NSDictionary *)requestBaseParams {
    
    return @{@"cmd":@"get_fill_constant_list",
             @"token":[[CLAppContext context] token],
             @"new_client":@"1",
             @"pay_version":[CLAppContext payVersion],
             @"client_type":[CLAppContext clientType]};
    
}


- (void)dealingWithRechargeData:(NSDictionary*)dict{
    
    self.rechargeData = [CLRechargeModel mj_objectWithKeyValues:dict];
}


- (NSMutableArray*) pullChannel {
    return self.rechargeData.channel_list;
}

- (NSArray*) pullFillList {
    return self.rechargeData.fill_list;
}

- (NSString *) pullTemplate{
    
    return self.rechargeData.template_value;
}

- (NSArray *) pullBigMoney{
    
    return self.rechargeData.big_moneny;
}
@end
