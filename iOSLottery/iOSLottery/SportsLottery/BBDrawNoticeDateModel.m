//
//  BBDrawNoticeDateModel.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/11.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBDrawNoticeDateModel.h"

@implementation BBDrawNoticeDateModel

+ (BBDrawNoticeDateModel *)drawNoticeDateModelWith:(NSString *)str
{
    
    NSArray *tempArr = [str componentsSeparatedByString:@"_"];
    
    //数据校验
    if (tempArr.count != 2) return nil;
    
    NSMutableArray *daysArr = [NSMutableArray arrayWithCapacity:0];
    
    //遍历天数
    for (int i = 1; i < [tempArr[1] intValue] + 1; i ++) {
        
        NSString *day = [NSString stringWithFormat:@"%d日",i];
        
        [daysArr addObject:day];
        
    }
    
    BBDrawNoticeDateModel *model = [[BBDrawNoticeDateModel alloc] init];
    
    model.titleName = tempArr[0];
    model.daysArray = daysArr;
    
    return model;
}

@end
