//
//  CKRechargeManager.m
//  iOSLottery
//
//  Created by 彩球 on 17/4/27.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CKRechargeManager.h"
#import "CKPayChannelFilter.h"
#import "CKPayChannelUISource.h"

@implementation CKRechargeConfig

@end


@interface CKRechargeManager () <CKPaychannelFilterDelegate>

@property (nonatomic, strong) CKPayChannelFilter* channelFilter;

@end

@implementation CKRechargeManager

#pragma mark - check channel

- (CKRechargeConfig*)checkAvailableChannelWithAmount:(long long)amount
{
    
    CKRechargeConfig* config = [CKRechargeConfig new];
    BOOL isValid = [self.channelFilter checkChannelValidStateWithAmount:amount channel:[self selectChannelDataSource]];
    
    config.channelVaildStatus = isValid;
    if (!isValid) {
        //渠道不可用
        
        //寻找推荐渠道
        NSNumber* recommandChannel = [self.channelFilter searchAvailableChannelWithAmount:amount];
    
        
        
        config.reasonTitle = [NSString stringWithFormat:@"超过%@单笔限额",[[self selectChannelDataSource] channel_name]];
                
        config.recommendChannelData = [[self.channelFilter channelDataDictionary] objectForKey:recommandChannel];
        config.recommendChannelTitle = [NSString stringWithFormat:@"%@%@",([config.recommendChannelData isVIP]?@"请联系":@"使用"),[config.recommendChannelData channel_name]];
        
    }
    
    return config;
    
}

#pragma mark - Public

- (void) setAvailableChannelList:(NSArray<id<CKPaychannelDataInterface>>*)channelList
                VIPChannelSource:(id<CKPaychannelDataInterface>)vipChannelData {
    
    
    
    [self.channelFilter setChannelDataSource:channelList];
    [self.channelFilter setVipPayChannelSource:vipChannelData];
    [self.channelFilter initChannel];
    [self.channelFilter sortAvailable];
    
    /* 默认渠道已经选择 */
    
   [self callback];
}

- (void)changeChannelId:(NSNumber *)channelId {
    
    self.channelFilter.selectedPayChannelId = channelId;
}


/* 支付渠道UI Source list*/
- (NSArray<id <CKPayChannelUISourceInterface>> *) channelUISource {
    
    NSMutableArray* tmpList = [NSMutableArray new];
    [self.channelFilter.enablePayChannelList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tmpList addObject:[self.channelFilter.channelUIDictionary objectForKey:obj]];
    }];
    
    return tmpList;
}
/* 支付渠道选择 UI Source */
- (id<CKPayChannelUISourceInterface>) selectChannelUISource {
    
    return [self.channelFilter.channelUIDictionary objectForKey:self.channelFilter.selectedPayChannelId];
}
/* 支付渠道选择 Data Source */
- (id<CKPaychannelDataInterface>) selectChannelDataSource {
    
    return self.channelFilter.selectedPaychannelSource;
}

#pragma mark - CKPaychannelFilterDelegate

- (void)filterFinishWith:(CKPayChannelFilter*)filter {
    
    [self callback];
}

#pragma mark - rechargeManager callback

- (void)callback {
    
    if ([self.delegate respondsToSelector:@selector(rechargeChannelFilterFinish)]) {
        [self.delegate rechargeChannelFilterFinish];
    }
}

#pragma mark - getter

- (CKPayChannelFilter *)channelFilter {
    
    if (!_channelFilter) {
        _channelFilter = [[CKPayChannelFilter alloc] initWithChannelUISource:[CKPayChannelUISource class] delegate:self];
    }
    return _channelFilter;
}

@end
