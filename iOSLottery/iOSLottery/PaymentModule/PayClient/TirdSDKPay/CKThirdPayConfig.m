//
//  CKSocialAndThirdPayConfig.m
//  caiqr
//
//  Created by 洪利 on 2017/5/3.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKThirdPayConfig.h"
#import "SPayClient.h"
@implementation CKThirdPayConfig

+ (void)resetUrlSchemesWithString:(NSString *)urlSchemes{
    if ([urlSchemes isEqualToString:juheScheme]) {
        SPayClientWechatConfigModel *weChatModel = [[SPayClientWechatConfigModel alloc] init];
        weChatModel.wapAppScheme = @"spaydemo";
        [[SPayClient sharedInstance] wechatpPayConfig:weChatModel];
    }
}


@end
