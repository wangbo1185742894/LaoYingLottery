//
//  CKRedPacketFilter.h
//  iOSLottery
//
//  Created by 彩球 on 17/4/13.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKRedPacketFilterInterface.h"


@class CKRedPacketFilter;

@protocol CKRedPacketFilterDelegate <NSObject>

- (void) redPacketFinishFilter:(CKRedPacketFilter*)filter;

@end



@interface CKRedPacketFilter : NSObject


/* 标识选择红包 或 设置选择红包 ID*/
@property (nonatomic, strong) NSString* cntSelectRedFid;

/* call back delegate */
@property (nonatomic, weak) id<CKRedPacketFilterDelegate> delegate;

/* 红包数据源  Setter */
@property (nonatomic, strong) NSArray<id<CKRedPacketDataSourceInterface>>* redSource;

/* 初始化  */
- (instancetype) initWithpacketUISource:(Class)UIClass delegate:(id<CKRedPacketFilterDelegate>)delegate;

//提供外部服务
/* 是否使用红包状态 */
@property (nonatomic, readonly) BOOL electedRedPacketStatus;

- (NSArray *) uiList;

- (NSDictionary *) sourceRedPacketDictionary;

- (NSDictionary *) uiRedPacketDictionary;

@end
