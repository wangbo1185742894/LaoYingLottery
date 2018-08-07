//
//  CLHomeGameEnteranceModel.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/21.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLHomeGameEnteranceModel.h"

@implementation CLHomeGameEnteranceModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"subEntrances":@"CLHomeGameEnteranceModel"};
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _subEntranceIsShow = NO;
    }
    return self;
}

- (void)setSubEntrances:(NSArray *)subEntrances
{
    NSMutableArray *gameEnArr = [NSMutableArray array];
    [subEntrances enumerateObjectsUsingBlock:^(CLHomeGameEnteranceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.contentUrl && obj.contentUrl.length?[gameEnArr addObject:obj]:nil;
    }];
    _subEntrances = gameEnArr;
}

@end
