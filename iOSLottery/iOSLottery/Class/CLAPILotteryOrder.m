//
//  CLLotteryFormAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/17.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLAPILotteryOrder.h"

/* 
    #name 数字彩追号方案详情API
    #e.g. /follow/detail/${followId}
    
    GET
    @param followId 追号方案ID
 */
NSString const *followDetailAPI = @"/follow/detail/";

/*
    #name 数字彩追号方案列表API
    #e.g. /follow/followList
 
    POST
    @param token
    @param currentPage
 */
NSString const *followListAPI = @"/follow/followList";





@implementation CLAPILotteryOrder


@end
