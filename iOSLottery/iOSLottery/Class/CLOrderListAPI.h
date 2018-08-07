//
//  CLOrderListAllAPI.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/11.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLLotteryBusinessRequest.h"


typedef NS_ENUM(NSInteger, CLAPIOrderListType){
    CLAPIOrderListTypeALL = 0,
    CLAPIOrderListTypeBonus = 1,
    CLAPIOrderListTypeWait = 2,
};


@protocol CLOrderListAPIDataHandler <NSObject>

/** 刷新数据 */
- (void)refresh;


/** 下一页 */
- (void)nextPage;

/** 处理数据 
 * 
 *  @param dict  待处理数据
 *  @param error 数据处理过程中错误信息
 *  return 数据处理成功状态
 */
- (BOOL)arrangeListWithAPIData:(NSDictionary*)dict error:(NSError**)error;


- (NSArray*)pullOrderList;

@end


@interface CLOrderListAPI : CLLotteryBusinessRequest <CLOrderListAPIDataHandler>

@property (nonatomic) CLAPIOrderListType apiListType;

@property (nonatomic, strong, readonly) NSMutableArray* orderList;

@property (nonatomic, assign) BOOL canLoadMore;

@property (nonatomic, strong) NSString *skipUrl;

@property (nonatomic, strong) NSString *bulletTips;

@property (nonatomic, assign) NSInteger ifSkipDownload;

@end




