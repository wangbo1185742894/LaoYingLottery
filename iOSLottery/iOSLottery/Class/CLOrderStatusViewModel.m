//
//  CLOrderStatusParam.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/17.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLOrderStatusViewModel.h"

@implementation CLOrderStatusViewModel

+ (CLOrderStatusViewModel*)defaultLineParams {
    
    CLOrderStatusViewModel* line = [CLOrderStatusViewModel new];
    line.statusType = CLOrderStatusTypeLine;
    line.lineLight = NO;
    return line;
}

+ (CLOrderStatusViewModel*)defaultDotParams {
    
    CLOrderStatusViewModel* dot = [CLOrderStatusViewModel new];
    dot.statusType = CLOrderStatusTypeDot;
    dot.dotType = CLOrderStatusDotTypeLight;
    dot.dotText = @"3";
    dot.dotTitle = @"支付成功";
    return dot;
    
}

- (void)setDotTypeWithFlagString:(NSString*)flag {
    
    if ([flag isEqualToString:@"R"]) {
        self.dotType = CLOrderStatusDotTypeLight;
    } else if ([flag isEqualToString:@"D"]) {
        self.dotType = CLOrderStatusDotTypeDark;
    } else if ([flag isEqualToString:@"Y"]) {
        self.dotType = CLOrderStatusDotTypeSuccess;
    } else if ([flag isEqualToString:@"N"] || [flag isEqualToString:@"X"]) {
        self.dotType = CLOrderStatusDotTypeFail;
    }
}

@end
