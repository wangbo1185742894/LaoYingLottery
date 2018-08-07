//
//  CLUpgradeRequest.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/22.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLUpgradeRequest.h"
#import "CLAppContext.h"
@implementation CLUpgradeRequest

- (NSDictionary *)requestBaseParams{
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithCapacity:0];
    [parm setObject:[CLAppContext clientType] forKey:@"clientType"];
    [parm setObject:[CLAppContext channelId] forKey:@"channel"];
    
    [parm setObject:[CLAppContext vNum] forKey:@"vNum"];
    return parm;
}
- (NSString *)requestBaseUrlSuffix {
    
    return @"/index/upgrade";
}

@end
