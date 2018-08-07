//
//  CLRedEnveOrderCreateAPI.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CKBaseAPI.h"

@interface CKRedEnveOrderCreateAPI : CKBaseAPI

@property (nonatomic, copy) NSString* amount;
@property (nonatomic, copy) NSString* need_channels_id;
@property (nonatomic, copy) NSString* pre_handle_token;
@property (nonatomic, strong) NSString *card_no;
@end
