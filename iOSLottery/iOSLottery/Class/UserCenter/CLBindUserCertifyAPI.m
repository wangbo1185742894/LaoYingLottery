//
//  CLBindUserCertifyAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/23.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBindUserCertifyAPI.h"
#import "CLAPI.h"
#import "CLAppContext.h"

@interface CLBindUserCertifyAPI () <CLBaseConfigRequest>

@end

@implementation CLBindUserCertifyAPI

- (NSString *)methodName {
    
    return @"bind_user_real_information";
}


- (NSDictionary *)requestBaseParams {
    
    return @{@"cmd":CMD_BindUserRealInfoAPI,
             @"token":[[CLAppContext context] token],
             @"real_name":self.realName,
             @"card_code":self.idCard};
}



@end
