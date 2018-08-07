//
//  CLBankCardListAPI.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/2.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLCaiqrBusinessRequest.h"

@interface CLBankCardListAPI : CLCaiqrBusinessRequest

@property (nonatomic, strong) NSString* type;

@property (nonatomic, strong) NSString* account_type_id;

- (NSArray*) pullData;

- (void) dealingWithCardListInfomationWithDict:(NSDictionary*) dict;

@end
