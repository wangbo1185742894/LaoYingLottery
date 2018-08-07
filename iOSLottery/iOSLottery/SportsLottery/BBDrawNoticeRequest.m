//
//  BBDrawNoticeRequest.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/11.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBDrawNoticeRequest.h"

#import "BBDrawNoticeGroupModel.h"
#import "BBDrawNoticeModel.h"
#import "BBDrawNoticeDateModel.h"

#import "BBDrawNoticeCell.h"

@interface BBDrawNoticeRequest ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *dateSelectArray;

@end

@implementation BBDrawNoticeRequest

- (NSString *)requestBaseUrlSuffix{
    
    return [NSString stringWithFormat:@"/index/notice/jc/%@", self.gameEn];
}

- (NSDictionary *)requestBaseParams
{
    
    if (self.drawNoticeTime.length > 0) return @{@"startTime":self.drawNoticeTime};
    
    
    return @{};
    
}


- (void)disposeDataWithDictionary:(NSDictionary *)dict;
{
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[BBDrawNoticeGroupModel mj_objectArrayWithKeyValuesArray:dict[@"noticeInfos"]]];
    
    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        BBDrawNoticeGroupModel *groupModel = obj;
        
        if (groupModel && groupModel.noticeInfo.count == 0) {
            
            BBDrawNoticeModel *model = [[BBDrawNoticeModel alloc] init];
            
            model.className = NSClassFromString(@"BBDrawNoticeNoDataCell");
            
            [groupModel.noticeInfo addObject:model];
            
            groupModel.noData = YES;
            
        }
    }];
    
    self.dataArray = tempArray;
    
    [self disposeDateSelectDataWithArray:dict[@"times"]];
    
}

//处理日期数据
- (void)disposeDateSelectDataWithArray:(NSArray *)array
{
    
    [self.dateSelectArray removeAllObjects];
    
    for (NSString *str in array) {
        
        
        BBDrawNoticeDateModel *model = [BBDrawNoticeDateModel drawNoticeDateModelWith:str];
        
        //插入数据，是为了保证数组升序排序
        if (model) [self.dateSelectArray insertObject:model atIndex:0];
        
    }
}

- (NSMutableArray *)getDataArray
{
    
    return self.dataArray;
    
}

- (NSArray *)getDateSelectArray
{
    
    return self.dateSelectArray;
}

- (NSInteger)getDateArrayCount
{
    return self.dataArray.count;
}

- (BBDrawNoticeGroupModel *)getGroupModelWithSection:(NSInteger)section
{
    
    BBDrawNoticeGroupModel *groupModel = self.dataArray[section];
    
    return groupModel;
}

- (BBDrawNoticeModel *)getNoticeModelWithSection:(NSInteger)section row:(NSInteger)row
{
    
    BBDrawNoticeGroupModel *groupModel = [self getGroupModelWithSection:section];
    
    BBDrawNoticeModel *noticeModel = groupModel.noticeInfo[row];
    
    return noticeModel;
}


- (NSMutableArray *)dataArray
{
    
    if (_dataArray == nil) {
        
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataArray;
}

- (NSMutableArray *)dateSelectArray
{
    
    if (_dateSelectArray == nil) {
        
        _dateSelectArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dateSelectArray;
}
    
    

@end
