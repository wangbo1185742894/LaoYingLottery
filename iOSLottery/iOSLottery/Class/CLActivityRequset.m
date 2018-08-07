//
//  CLActivityRequset.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/4/5.
//  Copyright © 2017年 caiqr. All rights reserved.

#import "CLActivityRequset.h"

#import "CLActivityModel.h"

@interface CLActivityRequset ()

/**
 数据数组
 */
@property (nonatomic, strong) NSMutableArray *activityArrays;

@end

@implementation CLActivityRequset

- (NSString *)requestBaseUrlSuffix
{
    return @"/user/activities";
}

//- (NSDictionary *)requestBaseParams{
//    
//    return @{@"cmd" : @"activity_get_activity_list"};
//}

//处理数据
- (void)dealingActivityArrayForDictionary:(id)dict
{
    if (self.activityArrays.count > 0) {
        
        [self.activityArrays removeAllObjects];
        
    }
        [self.activityArrays addObjectsFromArray:[CLActivityModel mj_objectArrayWithKeyValuesArray:dict]];
}

//返回处理完的数据数组
- (NSArray *)pullActivityDate
{
    return self.activityArrays;
}


#pragma mark --- lazyLoad --- 

- (NSMutableArray *)activityArrays
{
    if (_activityArrays == nil) {
        
        _activityArrays = [NSMutableArray new];
    }

    return _activityArrays;
}

@end
