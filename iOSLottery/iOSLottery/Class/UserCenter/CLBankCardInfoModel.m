//
//  CLBankCardInfoModel.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/2.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBankCardInfoModel.h"

@implementation CLBankCardInfoModel


- (void)setCard_type:(NSInteger)card_type
{
    _card_type = card_type;
    if (card_type == 2) {
        self.card_type_name =  @"信用卡";
    }else{
        self.card_type_name = @"储蓄卡";
    }
}

@end
