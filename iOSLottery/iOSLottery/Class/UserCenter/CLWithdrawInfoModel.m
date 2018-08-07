//
//  CLWithdrawInfoModel.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/13.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLWithdrawInfoModel.h"

@implementation CLWithdrawInfoModel

+ (NSDictionary*)objectClassInArray {
    
    return @{@"withdraw_list":@"CLWithdrawList"};
}

@end

@implementation CLWithdrawAccountInfo

@end


@implementation CLWithdrawList

+ (NSDictionary*)objectClassInArray {
    
    return @{@"channel_infos":@"CLBankCardInfoModel"};
}

@end
