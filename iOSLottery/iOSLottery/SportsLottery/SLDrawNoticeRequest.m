//
//  SLDrawNoticeRequest.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/23.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLDrawNoticeRequest.h"
#import "SLDrawNoticeGroupModel.h"
#import "SLDrawNoticeModel.h"
#import "SLDrawNoticeDateModel.h"

#import "SLDrawNoticeCell.h"

#import "SLDrawNoticeNoDataCell.h"

@interface SLDrawNoticeRequest ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *dateSelectArray;

@end

@implementation SLDrawNoticeRequest


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

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[SLDrawNoticeGroupModel mj_objectArrayWithKeyValuesArray:dict[@"noticeInfos"]]];
    
    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        SLDrawNoticeGroupModel *groupModel = obj;
                
        if (groupModel && groupModel.noticeInfo.count == 0) {
            
            SLDrawNoticeModel *model = [[SLDrawNoticeModel alloc] init];
            
            model.className = NSClassFromString(@"SLDrawNoticeNoDataCell");
            
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
        
        
        SLDrawNoticeDateModel *model = [SLDrawNoticeDateModel drawNoticeDateModelWith:str];
        
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

- (SLDrawNoticeGroupModel *)getGroupModelWithSection:(NSInteger)section
{
    
    SLDrawNoticeGroupModel *groupModel = self.dataArray[section];
    
    return groupModel;
}

- (SLDrawNoticeModel *)getNoticeModelWithSection:(NSInteger)section row:(NSInteger)row
{

    SLDrawNoticeGroupModel *groupModel = [self getGroupModelWithSection:section];

    SLDrawNoticeModel *noticeModel = groupModel.noticeInfo[row];

    return noticeModel;
}

- (BOOL)isCreateNoDateCell:(NSInteger)section;
{
    
    SLDrawNoticeGroupModel *groupModel = [self getGroupModelWithSection:section];
 
    return groupModel.isNoData;
}

- (id)createCell:(id)tableView;
{

    return [SLDrawNoticeCell createDrawNoticeCellWithTableView:tableView];
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
