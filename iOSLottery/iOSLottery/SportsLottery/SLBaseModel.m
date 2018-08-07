//
//  SLBaseModel.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/12.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLBaseModel.h"
#import <UIKit/UIKit.h>
//---------------------数据监测--------------------------

#define DataNotEmpty(a) (![(a) isKindOfClass:[NSNull class]] && (a != nil))
#define DataNotError(a) (![(a) isKindOfClass:[NSError class]])

NSString* NSStringFromValidData(id obj)
{
    if (DataNotEmpty(obj)) {
        if ([obj isKindOfClass:[NSString class]]) {
            return (NSString*)obj;
        }
    }
    return @"";
}

NSInteger NSIntegerFormValidData(id obj)
{
    if (DataNotEmpty(obj)) {
        return [obj integerValue];
    }
    return 0;
}

//赔率小数点保留位数控制
NSString* BetOddsTransitionString(id odds)
{
    CGFloat odd = [odds floatValue];
    if (odd >= 1000.f) {
        return [NSString stringWithFormat:@"%.0f",odd];
    } else if (odd >= 100.f) {
        return [NSString stringWithFormat:@"%.1f",odd];
    } else{
        return [NSString stringWithFormat:@"%.2f",odd];
    }
}


id NSValidData(id obj)
{
    if (DataNotEmpty(obj)) {
        return obj;
    }
    return nil;
}


@implementation SLBaseModel

@end
