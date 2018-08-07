//
//  CLOrderListAllAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/11.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLOrderListAPI.h"
#import "CLOrderListModel.h"
#import "CLAppContext.h"
@interface CLOrderListAPI () <CLBaseConfigRequest>

@property (nonatomic, assign) BOOL isLoadMore;

@property (nonatomic, strong) NSString *lastOrderTime;//上一次的订单id

@property (nonatomic, assign) BOOL ifNext;
@end

@implementation CLOrderListAPI

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _orderList = [NSMutableArray new];
        self.ifNext = YES;
    }
    return self;
}

#pragma mark - CLBaseConfigRequest

- (NSString *)methodName {
    
    return @"/order/orderList/All";
}

- (NSString *)requestBaseUrlSuffix {
    
    return @"/order/orderList";
}

- (NSDictionary*)requestBaseParams {
    
    return @{@"status":[NSString stringWithFormat:@"%zi",_apiListType], @"lastOrderTime" : self.lastOrderTime,@"channel":[CLAppContext channelId]};
}

#pragma mark - CLOrderListAPIDataHandler

- (void)refresh {
    
    self.isLoadMore = NO;
    [self start];
}

- (void)nextPage {
    
    self.isLoadMore = YES;
    [self start];
}
- (void)setIsLoadMore:(BOOL)isLoadMore{
    
    _isLoadMore = isLoadMore;
    
    if (!_isLoadMore) {
        //如果是刷新
        self.lastOrderTime = @"";
    }
}
/** 处理API返回数据 */
- (BOOL)arrangeListWithAPIData:(NSDictionary*)dict error:(NSError**)error
{
    NSArray *arr = nil;
    if ([dict isKindOfClass:[NSDictionary class]]) {
        arr = [CLOrderListModel mj_objectArrayWithKeyValuesArray:dict[@"orderVos"]];
        self.lastOrderTime = dict[@"lastOrderTime"];
        self.ifNext = ([dict[@"ifNext"] integerValue] == 1);
        self.skipUrl = dict[@"downloadUrl"];
        self.bulletTips = dict[@"bulletTips"];
        self.ifSkipDownload = [dict[@"ifSkipDownload"] integerValue];
    }else{
        arr = @[];
    }
    //是下拉刷新 清空数据
    if (!self.isLoadMore) {
        [self.orderList removeAllObjects];
    }
    [self.orderList addObjectsFromArray:arr];
    
    return YES;
}

- (NSArray*)pullOrderList {
    
    return self.orderList;
}

- (BOOL)canLoadMore{
    
    return self.ifNext;
}

@end
