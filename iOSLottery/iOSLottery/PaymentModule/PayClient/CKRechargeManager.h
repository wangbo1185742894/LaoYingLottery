//
//  CKRechargeManager.h
//  iOSLottery
//
//  Created by 彩球 on 17/4/27.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKPayChannelFilterInterface.h"


@protocol CKRechargeManagerDelegate <NSObject>

- (void)rechargeChannelFilterFinish;

@end

@interface CKRechargeConfig : NSObject

@property (nonatomic) BOOL channelVaildStatus;
@property (nonatomic, strong) NSString* recommendChannelTitle;
@property (nonatomic, strong) NSString* reasonTitle;
@property (nonatomic, strong) id<CKPaychannelDataInterface> recommendChannelData;

@end

@interface CKRechargeManager : NSObject

@property (nonatomic, weak) id<CKRechargeManagerDelegate> delegate;

/* 设置可用渠道列表 */
- (void) setAvailableChannelList:(NSArray<id<CKPaychannelDataInterface>>*)channelList
                VIPChannelSource:(id<CKPaychannelDataInterface>)vipChannelData;


- (void)changeChannelId:(NSNumber *)channelId;

- (CKRechargeConfig*)checkAvailableChannelWithAmount:(long long)amount;


/* 支付渠道UI Source list*/
- (NSArray<id <CKPayChannelUISourceInterface>> *) channelUISource;
/* 支付渠道选择 UI Source */
- (id<CKPayChannelUISourceInterface>) selectChannelUISource;
/* 支付渠道选择 Data Source */
- (id<CKPaychannelDataInterface>) selectChannelDataSource;



@end
