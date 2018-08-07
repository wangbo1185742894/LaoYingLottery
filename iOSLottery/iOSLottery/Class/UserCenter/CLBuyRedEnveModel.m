//
//  CLBuyRedEnveModel.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/12.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBuyRedEnveModel.h"

@implementation CLBuyRedEnveModel

+ (NSDictionary*) objectClassInArray {
    
    return @{@"channel_list":@"CLPaymentChannelInfo",
             @"red_list":@"CLBuyRedEnveSelectModel"};
}

@end
