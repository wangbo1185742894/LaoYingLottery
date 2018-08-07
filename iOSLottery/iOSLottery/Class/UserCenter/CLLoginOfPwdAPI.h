//
//  CLLoginOfPwdAPI.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/6.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLCaiqrBusinessRequest.h"

@interface CLLoginOfPwdAPI : CLCaiqrBusinessRequest

@property (nonatomic, copy) NSString* mobile;
@property (nonatomic, copy) NSString* password;

@end
