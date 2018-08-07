//
//  CLAddBankCardAPI.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/5.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLCaiqrBusinessRequest.h"

@interface CLAddBankCardAPI : CLCaiqrBusinessRequest

@property (nonatomic, strong) NSString* bankCardNO;
@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSString* account_type_id;

@end
