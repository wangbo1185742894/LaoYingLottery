//
//  CLSendVerifyCodeAPI.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/24.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLCaiqrBusinessRequest.h"

@interface CLSendVerifyCodeAPI : CLCaiqrBusinessRequest

@property (nonatomic, strong) NSString* mobile;

@end
