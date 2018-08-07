//
//  CKRedPacketFilterInterface.h
//  iOSLottery
//
//  Created by 彩球 on 17/4/13.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CKRedPacketDataSourceInterface <NSObject>

- (NSString*) redPacketFid;
- (NSString*) iconString;
- (NSString*) titleString;
- (NSString*) selectedTitleString;
- (NSString*) descColorString;
- (NSString*) descString;
- (long) redPacketBalance;
- (BOOL) defaultSelected;

@end



@protocol CKRedPacketUISourceInterface <NSObject>

//配置正常红包信息
- (void)viewModelConfigWithSource:(id<CKRedPacketDataSourceInterface>) source;

//修改选择状态
- (void)changeSelectState:(BOOL)state;

@optional
//配置不使用红包信息返回identifier
- (NSString*)identifierViewModelCreatedLastest;



@end

@protocol CKRedPacketFilterInterface <NSObject>


@end
