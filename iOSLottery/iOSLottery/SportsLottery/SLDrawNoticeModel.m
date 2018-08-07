//
//  SLDrawNoticeModel.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/23.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLDrawNoticeModel.h"

@implementation SLDrawNoticeModel

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _className = NSClassFromString(@"SLDrawNoticeCell");
    }
    
    return self;
}

@end
