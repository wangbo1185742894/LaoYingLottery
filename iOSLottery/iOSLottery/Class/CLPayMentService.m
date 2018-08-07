//
//  CLPayMentService.m
//  iOSLottery
//
//  Created by 小铭 on 2016/12/19.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLPayMentService.h"
#import "CLUserPaymentInfo.h"
#import "CLAccountInfoModel.h"
#import "CLQuickRedPacketsModel.h"
#import "CLUserPayAccountInfo.h"
@interface CLPayMentService()

@property (nonatomic, assign) long long userBalance;
/** 是否更换过支付方式 */
@property (nonatomic, readwrite) BOOL isUpdataPaySelected;

@end

@implementation CLPayMentService

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isUpdataPaySelected = NO;
    }
    return self;
}

#pragma mark - customMethod

- (void)changePaychannelWith:(id)payMentModel
{
    self.channelIndex = [self.paymentInfo.account_infos indexOfObject:payMentModel];
    self.isUpdataPaySelected = YES;
}

- (void)changeRedModelWith:(id)redModel
{
    self.redSelectedIndex = [self.paymentInfo.red_list indexOfObject:redModel];
    self.isUpdataPaySelected = NO;
}

- (void)upadatePaymentChannel
{
    if (self.redSelectedIndex >= 0 && !self.paymentInfo.red_list[self.redSelectedIndex].noRedSelected) {
        /** 只有红包支付 */
        if(self.paymentInfo.red_list[self.redSelectedIndex].balance_num >= self.paymentInfo.pre_handle_token.amount){
            self.needPayAmount = 0;
            self.payChannelID = -1;
            ///还原支付方式
            self.channelIndex = -1;
            return;
        }else{
            self.needPayAmount = self.paymentInfo.pre_handle_token.amount - self.paymentInfo.red_list[self.redSelectedIndex].balance_num;
        }
    }
    /** 如果选择了 不选择红包 */
    if(self.redSelectedIndex != -1 && self.paymentInfo.red_list[self.redSelectedIndex].noRedSelected) {
        
        self.needPayAmount = self.paymentInfo.pre_handle_token.amount;
        self.redSelectedIndex = -1;
    }
    if (self.needPayAmount == 0) return;
    /** 自动选择正确的支付方式 */
    
    [self.paymentInfo.account_infos enumerateObjectsUsingBlock:^(CLAccountInfoModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selectedStatus = NO;
    }];
    
    [self.paymentInfo.account_infos enumerateObjectsUsingBlock:^(CLAccountInfoModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        /** 重置选择状态 */
        obj.selectedStatus = NO;
        /** 判断支付方式的最低和最高限制 */
        obj.useStatus = NO;
        //支付的钱大于最低限额
        if (self.needPayAmount >= obj.minLimit) {
            //没有最大限制
            if (obj.maxLimit == 0 && obj.account_type_id != paymentChannelTypeAccountBalance) {
                obj.useStatus = YES;
            }else if(self.needPayAmount <= obj.maxLimit){
                obj.useStatus = YES;
            }
        }
        /** 选择正确的支付方式 */
        if (obj.useStatus) {
            if (self.isUpdataPaySelected) {
                //如果是手动选择的支付方式
                obj.selectedStatus = (self.channelIndex == idx);
                if (obj.selectedStatus) {
                    self.payChannelID = obj.account_type_id;
                    *stop = YES;
                }
            }else{
                //如果是自动匹配的支付方式
                obj.selectedStatus = YES;
                self.channelIndex = idx;
                self.payChannelID = obj.account_type_id;
                *stop = YES;
            }
        }
    }];
}

#pragma mark - settingMethod

- (void)setPaymentInfo:(CLUserPaymentInfo *)paymentInfo
{
    _paymentInfo = paymentInfo;
    //恢复默认更新状态
    self.isUpdataPaySelected = NO;
    paymentInfo.pre_handle_token.payAmountItemString = @"支付总额";
    /** 支付默认金额 */
    self.needPayAmount = paymentInfo.pre_handle_token.amount;
    /** 配置支付方式 */
    self.channelIndex = -1;
    if (paymentInfo.account_infos.count) {
        self.channelIndex = 0;
        [paymentInfo.account_infos enumerateObjectsUsingBlock:^(CLAccountInfoModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            /** 支付方式 配置限制 */
            obj.useStatus = YES;
            obj.minLimit = obj.account_type_id == paymentChannelTypeWx ? 2 : 0 ;
            obj.maxLimit = obj.account_type_id == paymentChannelTypeAccountBalance ? obj.balance * 100 : 0;
            if (obj.isDefault){
                obj.selectedStatus = YES;
                self.channelIndex = idx;
            }
        }];
    }
    
    /** 根据红包推荐更新红包选择状态 */
    self.redSelectedIndex = -1;
    if (paymentInfo.red_list.count) {
        /** 配置未选择红包样式 */
        CLQuickRedPacketsModel *noselectRedModel = [[CLQuickRedPacketsModel alloc] init];
        noselectRedModel.noRedSelected = YES;
        noselectRedModel.isSelected = NO;
        noselectRedModel.pay_name = @"不使用红包";
        [paymentInfo.red_list addObject:noselectRedModel];
        /** 默认选择红包为第一个 */
        self.redSelectedIndex = 0;
        [paymentInfo.red_list enumerateObjectsUsingBlock:^(CLQuickRedPacketsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.red_recommend) {
                obj.isSelected = YES;
                self.redSelectedIndex = idx;
                *stop = YES;
            }
        }];
    }
}
#pragma mark - gettingMethod
- (long long)userBalance
{
    /** 账户余额 */
    for (CLAccountInfoModel *cashInfo in self.paymentInfo.account_infos) {
        if (cashInfo.account_type_id == 1) {
            return (long long)(cashInfo.balance * 100);
            break;
        }
    }
    return 0;
}

- (NSArray *)paymentArr
{
    return self.paymentInfo.account_infos;
}

- (NSArray *)redModelArr
{
    return self.paymentInfo.red_list;
}

- (NSArray *)paymentDataSource
{
    NSMutableArray *paymentData = [NSMutableArray array];
    //如果没有支付渠道，返回空数据源
    if (self.paymentInfo.account_infos.count == 0) return paymentData;
    /** 更新支付方式 */
    [self upadatePaymentChannel];
    if (self.isQuickPayment) {
        /** 快速支付 */
        [paymentData addObject:@[self.paymentInfo.pre_handle_token,self.customObj]];
        
        
        /** 判断是否有红包 和 需要支付金额显示和数据源 */
        if (self.redSelectedIndex < 0) {
            //没有红包
            if (self.redModelArr.count) [paymentData addObject:[self.paymentInfo.red_list lastObject]];
            if (self.paymentInfo.account_infos.count > 0) {
                
                [paymentData addObject:self.paymentInfo.account_infos[self.channelIndex]];
            }
            
        }else{
            //有红包
            [paymentData addObject:self.paymentInfo.red_list[self.redSelectedIndex]];
            if (self.needPayAmount) {
                //红包金额不足
                if (self.channelIndex == -1) {
                    //还原支付方式
                }else if (self.channelIndex < self.paymentInfo.account_infos.count){
                    [paymentData addObject:self.paymentInfo.account_infos[self.channelIndex]];
                }
                
            }
        }
    }else{
        /** 正常支付 */
        [paymentData addObject:@[self.paymentInfo.pre_handle_token]];
        self.paymentInfo.pre_handle_token.isMarkednessRed = self.redSelectedIndex < 0;
        /** 判断是否有红包 和 需要支付金额显示和数据源 */
        NSMutableArray *redAndShowInfo = [NSMutableArray array];
    
        if (self.redSelectedIndex < 0) {
            //没有红包
            if (self.redModelArr.count) [redAndShowInfo addObject:self.redModelArr.lastObject];
        }else{
            //有红包
            [redAndShowInfo addObject:self.redModelArr[self.redSelectedIndex]];
            CLUserPayAccountInfo *orderShowAmountModel = [[CLUserPayAccountInfo alloc] init];
            orderShowAmountModel.payAmountItemString = @"还需支付";
            orderShowAmountModel.isMarkednessRed = YES;
            orderShowAmountModel.amount = self.needPayAmount;
            [redAndShowInfo addObject:orderShowAmountModel];
        }
        
        /** 如果红包 添加支付信息数据源 */
        if (self.redModelArr.count) [paymentData addObject:redAndShowInfo];
        /** 需要支付 数据源添加支付方式 */
        if (self.needPayAmount) [paymentData addObject:self.paymentInfo.account_infos];
    }
    return paymentData;
}

@end
