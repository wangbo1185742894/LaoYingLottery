//
//  CKPayChannelFilter.h
//  iOSLottery
//
//  Created by 彩球 on 17/4/11.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKPayChannelFilterInterface.h"

/*  
    切换红包     引起支付金额变化
    支付金额变化  引起渠道可用变化
    支付渠道切换  引起支付验证变化

 */
@class CKPayChannelFilter;

@protocol CKPaychannelFilterDelegate <NSObject>

- (void)filterFinishWith:(CKPayChannelFilter*)filter;

@end

typedef NS_ENUM(NSInteger, CKChannelVerifyType){
    
    CKChannelVerifyDefault = -1,
    CKChannelVerifyVIP = 0,
    CKChannelVerifyPayPwd = 1,
    CKChannelVerifyNothing = 2,
    CKChannelVerifyRealName = 3,
    CKChannelVerifyCardFront = 4,
};


@interface CKPayChannelAuthConfig : NSObject

@property (nonatomic) BOOL realNameAuth;
@property (nonatomic) BOOL existPayPwd;
@property (nonatomic) BOOL payFreeCertify;
@property (nonatomic) long long payFreeAmount;

@end



//支付渠道筛选业务

@interface CKPayChannelFilter : NSObject

//渠道UI数据map
@property (nonatomic, strong) NSMutableDictionary* channelUIDictionary;
//渠道源数据map
@property (nonatomic, strong) NSMutableDictionary* channelDataDictionary;


//可用支付渠道列表
@property (nonatomic, strong) NSMutableArray* enablePayChannelList;
//不可用支付渠道列表
@property (nonatomic, strong) NSMutableArray* unenablePayChannelList;
//vip渠道
@property (nonatomic, strong) NSMutableArray* vipPayChannelList;


//支付时获取真实支付渠道数据
@property (nonatomic, readonly, strong) id<CKPaychannelDataInterface> selectedPaychannelSource; //确定支付的渠道源数据




/* init */
- (instancetype) initWithChannelUISource:(Class)UIClass
                                delegate:(id<CKPaychannelFilterDelegate>)delegate;

/* 初始化渠道数据源 */
- (void) initChannel;

/* 设置支付渠道数据内容  Setter */
@property (nonatomic, strong) NSArray<id<CKPaychannelDataInterface>>* channelDataSource;

@property (nonatomic, strong) id<CKPaychannelDataInterface> onlyRedPayChannelSource;

@property (nonatomic, strong) id<CKPaychannelDataInterface> vipPayChannelSource;

/* 设置支付渠道 or 获取支付渠道 */
@property (nonatomic, strong) NSNumber* selectedPayChannelId; //支付渠道切换



/**
 设置需支付金额
 
 @Param amount 金额 (分)
 @Return 是否产生金额变化
 */
- (BOOL) setPayAmount:(long long)amount;


- (void) sortAvailable;
//



/* 检测渠道是否可用 */
- (BOOL) checkChannelValidStateWithAmount:(long long) amount channel:(id<CKPaychannelDataInterface>) channelData;
/* 查找可用渠道id */
- (NSNumber*)searchAvailableChannelWithAmount:(long long)amount;

- (void) payAuthTypeConfig:(CKPayChannelAuthConfig *)config title:(void(^)(NSString* title,CKChannelVerifyType type))title;


@end







