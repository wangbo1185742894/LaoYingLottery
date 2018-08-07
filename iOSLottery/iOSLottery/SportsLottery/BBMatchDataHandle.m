//
//  BBMatchDataHandle.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBMatchDataHandle.h"
#import "BBMatchGroupModel.h"

@interface BBMatchDataHandle ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation BBMatchDataHandle


- (void)disposeDataWithArray:(NSArray *)array
{

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[BBMatchGroupModel mj_objectArrayWithKeyValuesArray:array]];
    
    self.dataArray = tempArray;
}

- (NSArray *)getDataArray
{

    return self.dataArray;
}

- (NSMutableArray *)dataArray
{

    if (_dataArray == nil) {
        
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

@end
