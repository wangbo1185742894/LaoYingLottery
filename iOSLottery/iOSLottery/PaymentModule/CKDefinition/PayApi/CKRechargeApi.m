//
//  CKRechargeApi.m
//  caiqr
//
//  Created by 任鹏杰 on 2017/4/28.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKRechargeApi.h"
#import "CKPayChannelDataSource.h"
#import "CKPayClient.h"
#import "CKRechargeModel.h"
@interface CKRechargeApi ()

@property (nonatomic, strong) CKRechargeModel* rechargeData;

@end

@implementation CKRechargeApi

- (NSDictionary *)ck_requestBaseParams
{

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [dict setObject:@"get_fill_constant_list" forKey:@"cmd"];
    
    if([CKPayClient sharedManager].intermediary.token)[dict setObject:[CKPayClient sharedManager].intermediary.token forKey:@"token"];
    
    if ([[CKPayClient sharedManager].intermediary pay_version]) {
        [dict setObject:[[CKPayClient sharedManager].intermediary pay_version] forKey:@"pay_version"];
    }
    
    return dict;

}

- (void)dealingWithRechargeData:(NSDictionary*)dict{
    
    self.rechargeData = [CKRechargeModel objectWithKeyValues:dict];
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

- (NSArray *) pullLimit_list
{
    
    return self.rechargeData.fill_limit_list;
    
}

@end
