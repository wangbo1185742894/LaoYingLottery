//
//  CLUserLoginAPI.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/6.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLCaiqrBusinessRequest.h"

@interface CLUserLoginRegisterAPI : CLCaiqrBusinessRequest

@property (nonatomic, copy) NSString* mobile;
@property (nonatomic, copy) NSString* verify_code;

/* 用于第三方登录 */
@property (nonatomic, copy) NSDictionary* thirdLoginInfo;

/* 用于注册 */
@property (nonatomic, copy) NSString* loginPassword;

@end
