//
//  CLBindUserCertifyAPI.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/23.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLCaiqrBusinessRequest.h"

@interface CLBindUserCertifyAPI : CLCaiqrBusinessRequest

@property (nonatomic, strong) NSString* realName;
@property (nonatomic, strong) NSString* idCard;

@end
