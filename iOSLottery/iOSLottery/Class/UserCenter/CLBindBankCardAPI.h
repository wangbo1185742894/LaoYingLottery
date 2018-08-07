//
//  CLBindBankCardAPI.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/5.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLCaiqrBusinessRequest.h"

@interface CLBindBankCardAPI : CLCaiqrBusinessRequest

@property (nonatomic, copy) NSDictionary* bankCardBinDict;

@property (nonatomic, copy) NSString* card_code;

@property (nonatomic, copy) NSString* mobile;

@property (nonatomic, copy) NSString* certifyCode;

@end
