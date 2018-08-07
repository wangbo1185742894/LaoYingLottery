//
//  BBDrawNoticeGroupModel.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/11.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBDrawNoticeGroupModel.h"


@implementation BBDrawNoticeGroupModel

+ (NSDictionary *)mj_objectClassInArray
{
    
    return @{@"noticeInfo":@"BBDrawNoticeModel"};
    
}

- (instancetype)init
{
    
    self = [super init];
    
    if (self) {
        
        _visible = YES;
    }
    
    return self;
}

@end
