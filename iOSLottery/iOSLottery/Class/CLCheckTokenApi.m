//
//  CLCheckTokenApi.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/27.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLCheckTokenApi.h"
#import "CLAppContext.h"
#import "CLUserBaseInfo.h"
#import "CLSaveUserPassWordTool.h"
@implementation CLCheckTokenApi


//curl http://localhost:5678/api -d cmd=user_login_token_verify -d token='Z2LyHFwgOaqO6QmaWC5YsG3l8R8=' -d device_id='DSKNDFKSNDFJ' login_version
- (NSDictionary *)requestBaseParams{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setValue:@"user_login_token_verify" forKey:@"cmd"];    
    [dic setValue:@"240" forKey:@"login_version"];
    //设备信息
    if ([[CLAppContext context] device_id_uuid] && [[CLAppContext context] device_id_uuid].length > 0) {
        [dic setObject:[[CLAppContext context] device_id_uuid] forKey:@"device_id"];
    }
    if ([CLAppContext context].deviceModel && [CLAppContext context].deviceModel.length > 0) {
        
        [dic setObject:[CLAppContext context].deviceModel forKey:@"device_name"];
    }
    if ([CLAppContext context].deviceToken && [CLAppContext context].deviceToken.length > 0) {
        [dic setObject:[CLAppContext context].deviceToken forKey:@"device_token"];
    }
    return dic;
}

@end
