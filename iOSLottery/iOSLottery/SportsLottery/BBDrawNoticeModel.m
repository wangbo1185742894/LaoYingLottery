//
//  BBDrawNoticeModel.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/11.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBDrawNoticeModel.h"

@implementation BBDrawNoticeModel


- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _className = NSClassFromString(@"BBDrawNoticeCell");
    }
    
    return self;
}

@end
