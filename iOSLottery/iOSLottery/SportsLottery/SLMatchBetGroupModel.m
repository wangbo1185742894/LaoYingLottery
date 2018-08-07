//
//  SLMatchBetGroupModel.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/16.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLMatchBetGroupModel.h"
#import "SLMatchBetModel.h"

@implementation SLMatchBetGroupModel

+ (NSDictionary *)mj_objectClassInArray
{

    return @{@"matches":@"SLMatchBetModel"};

}

- (instancetype)init
{

    if (self = [super init]) {
        
        self.visible = YES;
        self.matches = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

@end
