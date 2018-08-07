//
//  CLBuyRedEnveSelectModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/12.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

@interface CLBuyRedEnveSelectModel : CLBaseModel

@property (nonatomic) long long amount_value;
@property (nonatomic) long long red_amount;
@property (nonatomic, strong) NSString* red_program_id;
@property (nonatomic, strong) NSString* show_name;

//Custom
@property (nonatomic) BOOL isCustom;

@end
