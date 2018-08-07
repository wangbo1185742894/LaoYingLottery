//
//  CLFollowDetailAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/17.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFollowDetailAPI.h"
#import "CLAPI.h"
#import "CLAppContext.h"

@interface CLFollowDetailAPI () <CLBaseConfigRequest>

@end

@implementation CLFollowDetailAPI

- (NSString *)methodName {
    
    return @"follow.detail";
}

- (NSString *)requestBaseUrlSuffix {
    
    return [NSString stringWithFormat:@"%@%@",followDetailAPI,self.followID];
}

- (NSDictionary *)requestBaseParams {
    return @{@"token":[[CLAppContext context] token]};
}

@end
