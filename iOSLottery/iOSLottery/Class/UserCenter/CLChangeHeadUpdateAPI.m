//
//  CLChangeHeadUploadAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/23.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLChangeHeadUpdateAPI.h"
#import "CLAPI.h"
#import "CLAppContext.h"

@interface CLChangeHeadUpdateAPI () <CLBaseConfigRequest>

@end

@implementation CLChangeHeadUpdateAPI

- (NSString *)methodName {
    
    return @"updateHeadImg";
}

- (NSDictionary *)requestBaseParams {
    
    return @{@"cmd":CMD_UpdateHeadImgAPI,
             @"token":[[CLAppContext context] token],
             @"head_img_url":self.headImgUrl};
}

@end
