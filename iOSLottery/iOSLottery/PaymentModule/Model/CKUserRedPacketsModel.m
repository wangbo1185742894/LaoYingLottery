//
//  CQUserRedPacketsModel.m
//  caiqr
//
//  Created by 小铭 on 16/4/18.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CKUserRedPacketsModel.h"
#import "CKUserRedPacketsBalanceDetailMemo.h"
#import "MJExtension.h"
@implementation CKUserRedPacketsModel

@end


@implementation CKUserRedPacketsDetailModel

- (void)setRed_table:(NSArray *)red_table
{
    _red_table = [CKUserRedPacketsBalanceDetailMemo objectArrayWithKeyValuesArray:red_table];
}

@end
