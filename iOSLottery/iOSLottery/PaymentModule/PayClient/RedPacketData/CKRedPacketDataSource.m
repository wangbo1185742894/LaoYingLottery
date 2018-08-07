//
//  CKRedPacketDataSource.m
//  iOSLottery
//
//  Created by 彩球 on 17/4/13.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CKRedPacketDataSource.h"

@implementation CKRedPacketDataSource

- (NSString *)redPacketFid {
    return self.fid;
}

- (NSString *)iconString {
    
    return nil;
}

- (long)redPacketBalance {
    
    return self.balance_num;
}

- (BOOL) defaultSelected {
    
    return self.red_recommend;
}

- (NSString *)titleString
{
    return self.pay_name;
}

- (NSString *)selectedTitleString
{
    return [NSString stringWithFormat:@"红包抵扣：%@",self.show_name];
}

- (NSString *)descColorString
{
    return [NSString stringWithFormat:@"%@",self.red_left_date_color?:@""];
}

- (NSString *)descString
{
    return [NSString stringWithFormat:@"%@",self.red_left_date?:@""];
}

@end
