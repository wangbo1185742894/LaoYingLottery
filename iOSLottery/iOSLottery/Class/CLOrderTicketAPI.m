//
//  CLOrderTicketAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/27.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLOrderTicketAPI.h"
#import "CLAppContext.h"
#import "CLOrderTicketModel.h"


@interface CLOrderTicketAPI () <CLBaseConfigRequest>

@property (nonatomic, strong) NSMutableArray* ticketArrays;

@end

@implementation CLOrderTicketAPI


- (NSString *)methodName {
    
    return @"/ticket/detail";
}

- (NSString *)requestBaseUrlSuffix {
    
    return @"/ticket/detail";
}

- (NSDictionary *)requestBaseParams {
    
    return @{@"token":[[CLAppContext context] token],
             @"orderId":self.orderId};
}


- (void)dealingwithTicketForDict:(NSDictionary*)dict {
    
    if (self.ticketArrays.count > 0) {
        [self.ticketArrays removeAllObjects];
    }
    [self.ticketArrays addObjectsFromArray:[CLOrderTicketModel mj_objectArrayWithKeyValuesArray:dict]];
}

- (NSArray*)pullData {
    
    return self.ticketArrays;
}

- (NSMutableArray *)ticketArrays {
    
    if (!_ticketArrays) {
        _ticketArrays = [NSMutableArray new];
    }
    return _ticketArrays;
}

@end
