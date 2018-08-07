//
//  CKRedPacketUISource.m
//  iOSLottery
//
//  Created by 彩球 on 17/4/13.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CKRedPacketUISource.h"

@implementation CKRedPacketUISource

- (void)viewModelConfigWithSource:(id<CKRedPacketDataSourceInterface>)source {
    
    self.fid = [source redPacketFid];
    self.imgStr = [source iconString];
    self.balanceStr = [NSString stringWithFormat:@"%ld",[source redPacketBalance]];
    self.title = [source titleString]?:@"";
    self.selectedTitle = [source selectedTitleString];
    self.selected = [source defaultSelected];
    self.balance = [source redPacketBalance];
    self.descString = [source descString];
    self.descColorString = [source descColorString];
}

- (void)changeSelectState:(BOOL)state {
    
    self.selected = state;
}

- (NSString*)identifierViewModelCreatedLastest {
    
    self.fid = @"-1";
    self.imgStr = @"";
    self.balanceStr = @"不使用红包";
    self.selectedTitle = @"不使用红包";
    self.title = @"不使用红包";
    self.selected = NO;
    self.balance = 0;
    self.descString = @"";
    return self.fid;
}

@end
