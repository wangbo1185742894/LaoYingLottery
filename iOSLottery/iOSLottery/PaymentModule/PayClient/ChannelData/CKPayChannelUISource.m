//
//  CKPayChannelUISource.m
//  iOSLottery
//
//  Created by 彩球 on 17/4/14.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CKPayChannelUISource.h"

@implementation CKPayChannelUISource

- (void)channelViewModelConfigWithSource:(id<CKPaychannelDataInterface>)source {
    
    
    self.channel_id = [source channel_id];
    
    if (self.channel_id == 1) {
        
        //金额精确小数点后两位
        NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                           
                                           decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                           
                                           scale:2
                                           
                                           raiseOnExactness:NO
                                           
                                           raiseOnOverflow:NO
                                           
                                           raiseOnUnderflow:NO
                                           
                                           raiseOnDivideByZero:YES];
        
        NSDecimalNumber* balance = [[NSDecimalNumber alloc] initWithLongLong:[source account_balance]];
        balance = [balance decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"100"] withBehavior:roundUp];
        //小数点仅显示非0字符
        self.channel_name = [NSString stringWithFormat:@"%@: %@元",[source channel_name],[balance stringValue]];
    } else {
        self.channel_name = [source channel_name];
    }
    self.channel_subtitle = [source channel_subName];
    self.channel_icon_str = [source channel_img];
    self.usability = YES;
    
}

/* 修改支付渠道被选择状态 */
- (void)changeChannelSelectState:(BOOL)state {
    [self setIsSelected:state];
}

@end
