//
//  CLBankCardListAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/2.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBankCardListAPI.h"
#import "CLAPI.h"
#import "CLBankCardInfoModel.h"
#import "CLAppContext.h"

@interface CLBankCardListAPI () <CLBaseConfigRequest>

@property (nonatomic, strong) NSMutableDictionary* api_params;

@property (nonatomic, strong) NSMutableArray* data;

@end

@implementation CLBankCardListAPI

- (NSString *)methodName {
    
    return @"";
}

- (NSDictionary *)requestBaseParams {
    
    if (self.api_params.count > 0)
        [self.api_params removeAllObjects];
    
    [self.api_params setObject:CMD_UserBindBankCardListAPI forKey:@"cmd"];
    [self.api_params setObject:[CLAppContext context].token forKey:@"token"];
    [self.api_params setObject:@"3" forKey:@"channel_type"];
    if(self.type) [self.api_params setObject:self.type forKey:@"type"];
    
    if(self.account_type_id) [self.api_params setObject:self.account_type_id forKey:@"account_type_id"];
    
    return self.api_params;
}

- (NSMutableDictionary *)api_params {
    
    if (!_api_params) {
        _api_params = [NSMutableDictionary new];
    }
    return _api_params;
}

- (NSArray*) pullData {
    
    return self.data;
}

- (void) dealingWithCardListInfomationWithDict:(NSDictionary*) dict {
    
    NSArray* objc = dict[@"channel_infos"];
    if (objc && [objc isKindOfClass:NSArray.class]) {
        if(self.data.count > 0) [self.data removeAllObjects];
        
        [self.data addObjectsFromArray:[CLBankCardInfoModel mj_objectArrayWithKeyValuesArray:objc]];
    }
}

- (NSMutableArray *)data {
    
    if (!_data) {
        _data = [NSMutableArray new];
    }
    return _data;
}

@end
