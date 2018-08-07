//
//  CLBuyRedEnveListAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/12.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBuyRedEnveListAPI.h"
#import "CLAPI.h"
#import "CLAppContext.h"
#import "CLBuyRedEnveModel.h"
#import "CLBuyRedEnveSelectModel.h"

@interface CLBuyRedEnveListAPI () <CLBaseConfigRequest>

@property (nonatomic, strong) CLBuyRedEnveModel* buyRedEnveData;

@property (nonatomic, strong) NSMutableArray* red_list;
@end

@implementation CLBuyRedEnveListAPI

- (NSString *)methodName {
    
    return @"get_red_constant_list";
    
}

- (NSDictionary *)requestBaseParams {
    
    return @{@"cmd":CMD_BuyRedEnvelopListAPI,
             @"token":[[CLAppContext context] token],
             @"new_client":@"1",
             @"pay_version":[CLAppContext payVersion]};
}

- (void)dealingWithRedEnvelopListFromDict:(NSDictionary *)dict {
    
    self.buyRedEnveData = [CLBuyRedEnveModel mj_objectWithKeyValues:dict];
    
}

- (NSArray*) channelList {
    
    return self.buyRedEnveData.channel_list;
}

- (NSString*) redCustomProgramId {
    
    return self.buyRedEnveData.red_custom_program_id;
}

- (NSArray*) redBuylist {
    //clear all data
    if (self.red_list.count > 0) {
        return self.red_list;
    }
    //if service red_list is nil  return @[];
    if (self.buyRedEnveData.red_list.count == 0) {
        return self.red_list;
    }
    //return red_list and custom obj
    if (self.buyRedEnveData.red_custom_program_id && self.buyRedEnveData
        .red_custom_program_id.length > 0) {
        CLBuyRedEnveSelectModel* customRed = [[CLBuyRedEnveSelectModel alloc] init];
        customRed.red_program_id = [self redCustomProgramId];
        customRed.show_name = @"";
        customRed.amount_value = 0;
        customRed.red_amount = 0;
        customRed.isCustom = YES;
        [self.red_list addObjectsFromArray:self.buyRedEnveData.red_list];
        [self.red_list addObject:customRed];
        customRed = nil;
    }
    return self.red_list;
}

//获取自定义红包模型
- (CLBuyRedEnveSelectModel*) getCustomRedEnveSelectModel {
    
    if (self.red_list.count == 0) return nil;
    
    for (CLBuyRedEnveSelectModel* obj in self.red_list) {
        if (obj.isCustom) {
            return obj;
        }
    }
    return nil;
}

//计算议价红包金额 修改自定义红包金额模型
- (NSString *)calculateCustomRedAmountWithSourc:(NSString *)sourceAmount
{
    NSInteger __block totalAmountNum = 0;
    NSInteger __block inputInteger = [sourceAmount integerValue];
    [self.buyRedEnveData.red_list enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(CLBuyRedEnveSelectModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        totalAmountNum += inputInteger / obj.amount_value * obj.red_amount;
        inputInteger = inputInteger % obj.amount_value;
    }];
    totalAmountNum += inputInteger;
    
    CLBuyRedEnveSelectModel* customModel = [self getCustomRedEnveSelectModel];
    if (customModel) {
        customModel.amount_value = [sourceAmount integerValue];
        customModel.red_amount = totalAmountNum;
    }
    
    return [NSString stringWithFormat:@"%zi",totalAmountNum];
}


- (NSMutableArray *)red_list {
    
    if (!_red_list) {
        _red_list = [NSMutableArray new];
    }
    return _red_list;
}

@end
