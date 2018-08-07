//
//  CQUserRedPacketsNewModel.m
//  caiqr
//
//  Created by huangyuchen on 2016/10/18.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CQUserRedPacketsNewModel.h"

@implementation CQUserRedPacketsNewModel

- (void)setRed_list:(NSArray<CQUserRedPacketsListModel *> *)red_list{
    _red_list = [CQUserRedPacketsListModel mj_objectArrayWithKeyValuesArray:red_list];
}

@end
@implementation CQUserRedPacketsListModel

@end
@implementation CQUserRedPacketsMemoModel

@end
