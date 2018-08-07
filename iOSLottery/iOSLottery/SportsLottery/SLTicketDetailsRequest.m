//
//  SLTicketDetailsRequest.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/6/7.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLTicketDetailsRequest.h"
#import "SLExternalService.h"
#import "SLTicketDetailsModel.h"
@interface SLTicketDetailsRequest ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SLTicketDetailsRequest

- (NSString *)requestBaseUrlSuffix
{

    return @"/ticket/detail/jc";
}

- (NSDictionary *)requestBaseParams
{

    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    if ([SLExternalService getToken] && [SLExternalService getToken].length > 0) {
        
        [dic setObject:[SLExternalService getToken] forKey:@"token"];
    }
    if (self.order_id && self.order_id.length > 0) {
        [dic setObject:self.order_id forKey:@"orderId"];
    }
    return dic;
}

- (void)disposeDataWithArray:(NSArray *)data
{
    

    NSArray *tempArray = [SLTicketDetailsModel mj_objectArrayWithKeyValuesArray:data];
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
    }
    for (SLTicketDetailsModel *model in tempArray) {
        
        for (SLTicketDetailsItemModel *itemModel in model.ticketVos) {
            
            [self.dataArray addObject:itemModel];
        }
    }
}

- (NSArray *)getDataArray
{

    return _dataArray;
}

- (NSInteger)getDataArrayCount
{

    return _dataArray.count;
}

- (SLTicketDetailsItemModel *)getTicketModelAtIndex:(NSInteger)index
{

    
    return self.dataArray[index];
}


- (NSMutableArray *)dataArray
{

    if (_dataArray == nil) {
        
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

@end
