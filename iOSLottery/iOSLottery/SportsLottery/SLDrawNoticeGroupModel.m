//
//  SLDrawNoticeGroupModel.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/19.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLDrawNoticeGroupModel.h"
#import "SLDrawNoticeModel.h"

@implementation SLDrawNoticeGroupModel

+ (NSDictionary *)mj_objectClassInArray
{
    
    return @{@"noticeInfo":@"SLDrawNoticeModel"};
    
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
