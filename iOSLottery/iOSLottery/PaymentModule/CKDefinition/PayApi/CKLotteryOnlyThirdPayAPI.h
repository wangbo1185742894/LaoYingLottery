//
//  CLLotteryOnlyThirdPayAPI.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CKBaseAPI.h"

@interface CKLotteryOnlyThirdPayAPI : CKBaseAPI

@property (nonatomic, copy) NSString* pre_handle_token;
@property (nonatomic, copy) NSString* amount;
@property (nonatomic, copy) NSString* card_no;
@property (nonatomic, copy) NSString* account_type_id;

@end
