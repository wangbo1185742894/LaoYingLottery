//
//  CLFirstStartRequest.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/18.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLFirstStartRequest.h"
#import <UIKit/UIKit.h>
#import "CLAppContext.h"
#import "CQDefinition.h"
@implementation CLFirstStartRequest


- (NSString *)requestBaseUrlSuffix{
    
    return @"/index/start";
}
- (NSDictionary *)requestBaseParams{

    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    [param setObject:[CLAppContext clientType] forKey:@"clientType"];
    [param setObject:[CLAppContext channelId] forKey:@"channel"];
    //设备信息
    if ([[CLAppContext context] device_id_uuid] && [[CLAppContext context] device_id_uuid].length > 0) {
        [param setObject:[[CLAppContext context] device_id_uuid] forKey:@"deviceId"];
    }
    if ([CLAppContext context].deviceModel && [CLAppContext context].deviceModel.length > 0) {
        
        [param setObject:[CLAppContext context].deviceModel forKey:@"deviceName"];
    }
    if ([CLAppContext context].deviceToken && [CLAppContext context].deviceToken.length > 0) {
        [param setObject:[CLAppContext context].deviceToken forKey:@"deviceToken"];
    }
    [param setObject:APP_VERSION forKey:@"appVersion"];
    [param setObject:[NSString stringWithFormat:@"%f",IOS_VERSION] forKey:@"osVersion"];
    
    if ([[CLAppContext context] token] && [[CLAppContext context] token].length > 0) {
        
        [param setObject:[[CLAppContext context] token] forKey:@"loginToken"];
    }
    return param;
}
@end
