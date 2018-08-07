//
//  CKPayChannelDataSource.m
//  iOSLottery
//
//  Created by 彩球 on 17/4/14.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CKPayChannelDataSource.h"

@implementation CKPayChannelDataSource

- (NSInteger)channel_id {
    
    return  self.account_type_id;
}

- (NSString *)channel_name {
    
    return self.account_type_nm;
}

- (BOOL)default_option {
    
    return self.is_default_option;
}

- (NSInteger)channel_limit_max {
    return self.highest_pay_amount;
}

- (NSInteger)channel_limit_mix {
    
    return self.lowest_pay_amount;
}

- (BOOL)channel_need_pay_pwd {
    
    return self.need_pay_pwd;
}

- (BOOL)channel_need_real_name {
    
    return self.need_real_name;
}

- (BOOL)channel_need_card_bin {
    
    return self.need_card_bin;
}

- (NSString *)channel_img {
    
    return self.img_url;
}
- (NSString *)channel_subName{
    
    return self.memo;
}

- (NSString *)url_prefix{
    return self.backup_1;
}

- (long long) account_balance {
    return self.balance * 100;
}

- (BOOL)isVIP {
    
    return self.isVipChannel;
}

- (void)setConfigVIP:(BOOL)configVIP {
    
    self.isVipChannel = configVIP;
}

#pragma mark - Public 

+ (CKPayChannelDataSource*) initOnlyRedPacketPayChannel {
    
    CKPayChannelDataSource* source = [[CKPayChannelDataSource alloc] init];
    source.account_type_id = 0;
    source.need_pay_pwd = YES;
    source.need_card_bin = source.need_real_name = NO;
    return source;
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    
    CKPayChannelDataSource* copy = [[[self class] allocWithZone:zone] init];
    
    copy->_account_type_id = self.account_type_id;
    copy->_account_type_nm = self.account_type_nm;
    copy->_balanceStr = self.balanceStr;
    copy->_is_default_option = self.is_default_option;
    copy->_unit = self.unit;
    copy->_need_card_bin = self.need_card_bin;
    copy->_need_pay_pwd = self.need_pay_pwd;
    copy->_need_real_name = self.need_real_name;
    copy->_highest_pay_amount = self.highest_pay_amount;
    copy->_lowest_pay_amount = self.lowest_pay_amount;
    
    return copy;
}


@end
