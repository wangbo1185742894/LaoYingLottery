//
//  CKPayFlowFilter.h
//  iOSLottery
//
//  Created by 彩球 on 17/4/14.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKRedPacketDataSource.h"
#import "CKRedPacketUISource.h"

#import "CKPayChannelDataSource.h"
#import "CKPayChannelUISource.h"

#import "CKPayChannelFilter.h"
#import "CKRedPacketFilter.h"

#import "CKRedPacketFilterInterface.h"

@interface CKPayChannelVerifyMark : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* subTitle;

@property (nonatomic) BOOL isVIP;
@property (nonatomic) BOOL isAuthenticate;
@property (nonatomic, strong) NSString* phone;

@end


@protocol CKPayFlowFilterDelegate  <NSObject>

- (void) flowFilterFinish;

@end

@interface CKPayFlowFilter : NSObject


@property (nonatomic,weak) id<CKPayFlowFilterDelegate> delegate;

/* 需支付的金额 */
@property (nonatomic, readonly) long long needPayAmount;
//支付总额
@property (nonatomic) long long totalAmount;
- (void) test;

/* 设置可用渠道列表 */
- (void) setAvailableChannelList:(NSArray<id<CKPaychannelDataInterface>>*)channelList
                VIPChannelSource:(id<CKPaychannelDataInterface>)vipChannelData
                   redPacketList:(NSArray<id<CKRedPacketDataSourceInterface>>*)redPacketList
                     totalAmount:(long long)amount;




- (void)changeChannelId:(NSNumber*)channelId;
- (void)changeRedPacketId:(NSString*)redPacketId;


/* 支付渠道UI Source list*/
- (NSArray<id <CKPayChannelUISourceInterface>> *) channelUISource;
/* 支付渠道选择 UI Source */
- (id<CKPayChannelUISourceInterface>) selectChannelUISource;
/* 支付渠道选择 Data Source */
- (id<CKPaychannelDataInterface>) selectChannelDataSource;

- (CKPayChannelVerifyMark* )channelGuidTitle;


/* 标识是否存在红包 */
- (BOOL) existRedPacket;
/* 是否使用红包 */
- (BOOL) isUseRedPacket;
/* 红包列表 UI Source list */
- (NSArray<id <CKRedPacketUISourceInterface>> *) redPacketUISource;
/* 红包选择 UI Source */
- (id<CKRedPacketUISourceInterface>) selectRedPacketUISource;
/* 红包选择 Data Source */
- (id<CKRedPacketDataSourceInterface>) selectRedPacketDataSource;



@end
