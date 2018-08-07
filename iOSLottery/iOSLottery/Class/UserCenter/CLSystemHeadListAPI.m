//
//  CLSystemHeadListAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/23.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLSystemHeadListAPI.h"
#import "CLAPI.h"


@interface CLSystemHeadListAPI () <CLBaseConfigRequest>

@end

@implementation CLSystemHeadListAPI

- (NSString *)methodName {
    
    return @"getSystemHeadList";
}

- (NSDictionary *)requestBaseParams {
    
    return @{@"cmd":CMD_SystemHeadImgListAPI};
}

@end
