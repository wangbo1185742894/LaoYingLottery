//
//  CLBankCardInfoModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/2.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

@interface CLBankCardInfoModel : CLBaseModel

@property (nonatomic, strong) NSString* real_name;
@property (nonatomic, strong) NSString* card_no;
@property (nonatomic, strong) NSString* bank_short_name;
@property (nonatomic, strong) NSString* issuer_bank_province;
@property (nonatomic, strong) NSString* issuer_bank_city;
@property (nonatomic, strong) NSString* sub_bank_name;
@property (nonatomic, strong) NSString* bank_img_url;
@property (nonatomic, assign) NSInteger status;
/**  银行卡类型 1.储蓄卡 2.信用卡 默认储蓄卡 */
@property (nonatomic, assign) NSInteger card_type;
@property (nonatomic, strong) NSString *card_type_name;
@property (nonatomic, strong) NSString *withdraw_memo;
@property (nonatomic, strong) NSString *mobile;

//@property (nonatomic, readwrite) BOOL bankCardIsSelected;

@end
