//
//  CKPayChannelFilter.m
//  iOSLottery
//
//  Created by 彩球 on 17/4/11.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CKPayChannelFilter.h"

#define NONE_CHANNEL_ID [NSNumber numberWithInteger:-1]
#define ONLYRED_CHANNEL_ID  [NSNumber numberWithInteger:0]
#define VIP_CHANNEL_ID [NSNumber numberWithInteger:999]

@interface CKPayChannelFilter ()

//源数据内部顺序索引 <内部>
@property (nonatomic, strong) NSMutableArray<NSNumber*> *channelIdxSourceArray;

//渠道源数据 <内部>
@property (nonatomic, strong) NSMutableArray<id<CKPaychannelDataInterface>>* channelSourceArray;

//记录上一次选择渠道列表
@property (nonatomic, strong) NSNumber* historySelectedChannelId;

@property (nonatomic) long long needPayAmount; //需支付金额   金额计算在前一步进行(红包与订单金额处理逻辑)

/* 代理 */
@property (nonatomic, weak) id<CKPaychannelFilterDelegate> delegate;

@property (nonatomic, strong) Class uiClass;

@end

@implementation CKPayChannelFilter

BOOL channelISNull(NSNumber * number) {
    
    return ((number != NONE_CHANNEL_ID) && (number != ONLYRED_CHANNEL_ID) && (number != VIP_CHANNEL_ID));
}


- (id)selectedPaychannelSource {
    
   return [self.channelDataDictionary objectForKey:self.selectedPayChannelId];
}
//Source:(NSArray<id<CKPaychannelDataInterface>>*)source
- (instancetype) initWithChannelUISource:(Class)UIClass
                              delegate:(id<CKPaychannelFilterDelegate>)delegate
{
    
    self = [super init];
    if (self) {
        self.delegate = delegate;
        _needPayAmount = -1;
        _selectedPayChannelId = _historySelectedChannelId = NONE_CHANNEL_ID;
        
        self.channelSourceArray = [NSMutableArray arrayWithCapacity:0];
        self.channelIdxSourceArray = [NSMutableArray arrayWithCapacity:self.channelSourceArray.count];
        self.channelDataDictionary = [NSMutableDictionary dictionaryWithCapacity:self.channelSourceArray.count];
        self.channelUIDictionary = [NSMutableDictionary dictionaryWithCapacity:self.channelSourceArray.count];
        
        self.enablePayChannelList = [NSMutableArray new];
        self.unenablePayChannelList = [NSMutableArray new];
        self.vipPayChannelList = [NSMutableArray new];
        
        self.uiClass = UIClass;
        
    }
    return self;
}

- (void)setVipPayChannelSource:(id<CKPaychannelDataInterface>)vipPayChannelSource {
    
    _vipPayChannelSource = vipPayChannelSource;
    _vipPayChannelSource.configVIP = YES;
}

- (BOOL) setPayAmount:(long long)amount {
    
    if (_needPayAmount == amount) return NO;  //金额未发生变化
    
    _needPayAmount = amount;
    
    [self filterChannel];
    
    return YES;
}

/* 初始化支付渠道及源数据和UI数据Dict */
- (void) initChannel {
    
    /* 清空存储 渠道源数据,渠道id列表,渠道源数据Dict,渠道UI数据Dict */
    [self.channelSourceArray removeAllObjects];
    [self.channelIdxSourceArray removeAllObjects];
    [self.channelDataDictionary removeAllObjects];
    [self.channelUIDictionary removeAllObjects];
    
    [self.channelSourceArray addObjectsFromArray:[self.channelDataSource mutableCopy]];
    //初始化可用渠道
    [self.channelSourceArray enumerateObjectsUsingBlock:^(id<CKPaychannelDataInterface>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSNumber *channel_id = [NSNumber numberWithInteger:[obj channel_id]];
        //保存channel id
        [self.channelIdxSourceArray addObject:channel_id];
        //保存源数据到map中
        [self.channelDataDictionary setObject:obj forKey:channel_id];
        
        //ui数据map
        id<CKPayChannelUISourceInterface> uiSource = [[self.uiClass alloc] init];
        [uiSource channelViewModelConfigWithSource:obj];
        [self.channelUIDictionary setObject:uiSource forKey:channel_id];
        
        //设置默认选择渠道
        if (!channelISNull(self.selectedPayChannelId) && [obj default_option]) {
            _selectedPayChannelId = [NSNumber numberWithInteger:[obj channel_id]];
            _historySelectedChannelId = _selectedPayChannelId;
            [uiSource setIsSelected:YES];
        }
    }];
    
    if (_onlyRedPayChannelSource) {
        [self.channelDataDictionary setObject:_onlyRedPayChannelSource forKey:ONLYRED_CHANNEL_ID];
    }
    
    if (_vipPayChannelSource) {
        NSNumber *vip_id = [NSNumber numberWithLongLong:[_vipPayChannelSource channel_id]];
        [self.channelDataDictionary setObject:_vipPayChannelSource forKey:vip_id];
        id<CKPayChannelUISourceInterface> uiSource = [[self.uiClass alloc] init];
        [uiSource channelViewModelConfigWithSource:_vipPayChannelSource];
        [uiSource setUsability:YES];
        [uiSource setIsSelected:YES];
        [self.channelUIDictionary setObject:uiSource forKey:vip_id];
    }
}

#pragma mark - 渠道筛选

//可用渠道/不可用渠道筛选
- (void)filterChannel{
    
    [self clearChannelIdList];
    
    //金额小于或等于0元,即不需要支付渠道,顾红包可以全额抵扣,设置仅红包支付渠道id
    if (_needPayAmount <= 0) {
        //不需要支付渠道配合  如果存在
        _selectedPayChannelId = (self.onlyRedPayChannelSource)?ONLYRED_CHANNEL_ID:NONE_CHANNEL_ID;
        [self callback];
        return;
    }
    
    [self.channelIdxSourceArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //
        id<CKPaychannelDataInterface> data = [self.channelDataDictionary objectForKey:obj];
        id<CKPayChannelUISourceInterface> ui = [self.channelUIDictionary objectForKey:obj];
        
        BOOL canPay = [self checkChannelValidStateWithAmount:_needPayAmount channel:data];
        
        
        /* 渠道金额支持支付
         
         判断ui是否可用
         将可用的渠道id增加到可用数组中  不可用增加到不可用数组中
         设置不可用渠道状态文字
         
         */
        
        [ui setUsability:canPay];
        //将所有渠道的选择状态置为NO
        [ui setIsSelected:NO];
        
        if (canPay) {
            [self.enablePayChannelList addObject:obj];
            [ui setChannel_state_msg:@""];
        } else {
            NSString* state_msg = @"";
            NSInteger limit_mix = ([data channel_limit_mix] <= 100)?0:([data channel_limit_mix] - 100);
            if ((_needPayAmount <= limit_mix)) {
                state_msg = [NSString stringWithFormat:@"大于%zi元可使用",(limit_mix / 100)];
            } else if ((_needPayAmount > [data channel_limit_max])){
                if ([data channel_id] == 1) {
                    state_msg = @"余额不足";
                } else {
                    state_msg = @"超过最大限额";
                }
            }
            [ui setChannel_state_msg:state_msg];
            [self.unenablePayChannelList addObject:obj];
        }
    }];
    
    //根据可用与不可用渠道列表匹配当前选择支付渠道
    [self configSelectChannel];
}

//判断渠道是否可用
- (BOOL) checkChannelValidStateWithAmount:(long long) amount channel:(id<CKPaychannelDataInterface>) channelData {
    
    NSInteger limit_mix = ([channelData channel_limit_mix] <= 100)?0:([channelData channel_limit_mix] - 100);
    return ((amount > limit_mix) && amount <= [channelData channel_limit_max]);
}

- (NSNumber*)searchAvailableChannelWithAmount:(long long)amount{
    
    __block NSNumber* __channel = NONE_CHANNEL_ID;
    [self.channelIdxSourceArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        id<CKPaychannelDataInterface> data = [self.channelDataDictionary objectForKey:obj];
        if ( [self checkChannelValidStateWithAmount:amount channel:data]) {
            __channel = obj;
            *stop = YES;
        }
    }];
    
    
    if (__channel == NONE_CHANNEL_ID) {
        //未找到可用渠道
        if (self.vipPayChannelSource) {
            __channel = [NSNumber numberWithInteger:[self.vipPayChannelSource channel_id]];
        }
        
    }
    
    return __channel;
}

#pragma mark - 根据渠道筛选匹配当前选择渠道id

- (void) configSelectChannel {
    
    _selectedPayChannelId = _historySelectedChannelId;
    //若上次渠道为 仅红包或不可用时 且历史选择有内容时  将历史选择设置为当前选择
//    if ((_selectedPayChannelId == ONLYRED_CHANNEL_ID) ||
//        (_selectedPayChannelId == NONE_CHANNEL_ID) ||
//        (_selectedPayChannelId == VIP_CHANNEL_ID)) {
//        if ((_historySelectedChannelId != ONLYRED_CHANNEL_ID) &&
//            (_historySelectedChannelId != NONE_CHANNEL_ID) &&
//            (_historySelectedChannelId != VIP_CHANNEL_ID)) {
//            _selectedPayChannelId = _historySelectedChannelId;
//        }
//    }
    
    //若当前选择为None 或者 实际渠道id 判断可用是否存在,如果可用不存在  设置None 若存在且包含 则
    if (self.enablePayChannelList.count > 0) {
        //有可用支付渠道
        if (![self.enablePayChannelList containsObject:self.selectedPayChannelId]) {
            _selectedPayChannelId = [self.enablePayChannelList firstObject];
            _historySelectedChannelId = _selectedPayChannelId;
        }
        
        id<CKPayChannelUISourceInterface> ui = [self.channelUIDictionary objectForKey:_selectedPayChannelId];
        [ui setIsSelected:YES];
    } else {
        //无可用支付渠道
        //存在vip渠道  设置vip渠道
        BOOL showVIP = ((_vipPayChannelSource != nil) && _vipPayChannelSource.isVIP);
        if (showVIP) {
            _selectedPayChannelId = [NSNumber numberWithLongLong:[_vipPayChannelSource channel_id]];
            [self.vipPayChannelList addObject:_selectedPayChannelId];
        } else {
            _selectedPayChannelId = NONE_CHANNEL_ID;
        }
    }
    [self callback];
}

#pragma mark - 切换支付渠道（不支持切换仅红包支付渠道）

- (void)setSelectedPayChannelId:(NSNumber *)selectedPayChannelId {
    
    //切换渠道 不对渠道进行筛选,仅对渠道UISource Selected状态进行修改
    if (selectedPayChannelId == NONE_CHANNEL_ID)return;
    
    if (_selectedPayChannelId == selectedPayChannelId) return;
    
    //重置上次是渠道选择状态
    if ([[self.channelUIDictionary allKeys] containsObject:_selectedPayChannelId]) {
        id<CKPayChannelUISourceInterface> ui = [self.channelUIDictionary objectForKey:_selectedPayChannelId];
        [ui setIsSelected:NO];
    }
    
    _selectedPayChannelId = selectedPayChannelId;
    if (_selectedPayChannelId != ONLYRED_CHANNEL_ID) {
        _historySelectedChannelId = _selectedPayChannelId;
    }
    
    //设置本次渠道选择状态
    if ([[self.channelUIDictionary allKeys] containsObject:_selectedPayChannelId]) {
        id<CKPayChannelUISourceInterface> ui = [self.channelUIDictionary objectForKey:_selectedPayChannelId];
        [ui setIsSelected:YES];
    }
    
    //切换验证方式
    [self callback];
    
}



#pragma mark - sort pay channel

- (void) sortAvailable {
    
    [self.enablePayChannelList removeAllObjects];
    [self.enablePayChannelList addObjectsFromArray:self.channelIdxSourceArray];
}


#pragma mark - 回调

- (void)callback {
    if ([self.delegate respondsToSelector:@selector(filterFinishWith:)]) {
        [self.delegate filterFinishWith:self];
    }
}

#pragma mark - 清空所有UI展示数据

- (void) clearChannelIdList {
    
    [self.enablePayChannelList removeAllObjects];
    [self.unenablePayChannelList removeAllObjects];
    [self.vipPayChannelList removeAllObjects];
}

@end
