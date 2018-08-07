//
//  CLLoginRegisterAdapter.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/7.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLLoginRegisterAdapter : NSObject

+ (void) loginSuccessWithMessage:(NSDictionary*)loginMsg;

+ (void) logout;

+ (BOOL) hasLoginPassword;

@end
