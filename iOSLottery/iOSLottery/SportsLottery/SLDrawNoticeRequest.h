//
//  SLDrawNoticeRequest.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/23.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLLotteryBusinessRequest.h"

@class SLDrawNoticeGroupModel,SLDrawNoticeModel;

@interface SLDrawNoticeRequest : CLLotteryBusinessRequest<CLBaseConfigRequest>

@property (nonatomic, strong) NSString *gameEn;

@property (nonatomic, strong) NSString *drawNoticeTime;

/**
 处理请求数据
 */
- (void)disposeDataWithDictionary:(NSDictionary *)dict;

/**
 获取数据
 */
- (NSMutableArray *)getDataArray;

/**
 获取日期选择数据
 */
- (NSArray *)getDateSelectArray;

/**
 获取数组长度
 */
- (NSInteger)getDateArrayCount;

/**
 获取组模型
 */
- (SLDrawNoticeGroupModel *)getGroupModelWithSection:(NSInteger)section;

/**
 获取投注模型
 */
- (SLDrawNoticeModel *)getNoticeModelWithSection:(NSInteger)section row:(NSInteger)row;



@end
