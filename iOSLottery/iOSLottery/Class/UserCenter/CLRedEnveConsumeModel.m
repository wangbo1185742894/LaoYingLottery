//
//  CLRedEnveConsumeModel.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/29.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLRedEnveConsumeModel.h"

@implementation CLRedEnveConsumeModel

- (void)setCreate_time:(NSString *)create_time
{
    _create_time = [create_time stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}

@end
