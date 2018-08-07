//
//  CKPayFlowFilter.m
//  iOSLottery
//
//  Created by 彩球 on 17/4/14.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CKPayFlowFilter.h"
#import "CKPayChannelDataSource.h"
#import "CKPayChannelUISource.h"
#import "CKPayChannelFilter.h"


#import "CKRedPacketUISource.h"
#import "CKRedPacketDataSource.h"
#import "CKRedPacketFilter.h"

#import "CKPayClient.h"

@implementation CKPayChannelVerifyMark

@end

@interface CKPayFlowFilter () <CKPaychannelFilterDelegate,CKRedPacketFilterDelegate>

@property (nonatomic, strong) CKPayChannelFilter* channelFilter;
@property (nonatomic, strong) CKRedPacketFilter* redPacketFilter;


@end

@implementation CKPayFlowFilter

//- (void) test  {
//    
//    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:0];
//    for (int i = 0; i < 9; i++) {
//        CKPayChannelDataSource* one = [CKPayChannelDataSource new];
//        one.account_type_id = i + 1;
//        one.account_type_nm = [NSString stringWithFormat:@"渠道%zi",i + 1];
//        one.is_default_option = (i == 0);
//        one.balanceStr = @"100";
//        one.lowest_pay_amount = (i == 0)?0:100;
//        one.highest_pay_amount = (i == 0)?0:2000;
//        one.unit = @"元";
//        if (i == 0) {
//            one.need_real_name = YES;  //100
//            one.need_pay_pwd = NO;
//            one.need_card_bin = NO;
//        } else if (i == 1) {
//            one.need_real_name = YES;  //110
//            one.need_pay_pwd = YES;
//            one.need_card_bin = NO;
//        } else if (i == 2) {
//            one.need_real_name = YES;  //111
//            one.need_pay_pwd = YES;
//            one.need_card_bin = YES;
//        } else if (i == 3) {
//            one.need_real_name = NO;  //000
//            one.need_pay_pwd = NO;
//            one.need_card_bin = NO;
//        } else if (i == 4) {
//            one.need_real_name = NO; //010
//            one.need_pay_pwd = YES;
//            one.need_card_bin = NO;
//        } else if (i == 5) {
//            one.need_real_name = NO; //011
//            one.need_pay_pwd = YES;
//            one.need_card_bin = YES;
//        } else if (i == 6) {
//            one.need_real_name = YES; //101
//            one.need_pay_pwd = NO;
//            one.need_card_bin = YES;
//        } else if (i == 7) {
//            one.need_real_name = NO; //001
//            one.need_pay_pwd = NO;
//            one.need_card_bin = YES;
//        } else if (i == 8) {
//            one.need_real_name = NO; //010
//            one.need_pay_pwd = YES;
//            one.need_card_bin = NO;
//        }
//        
//        [arr addObject:one];
//        one = nil;
//    }
//    
//    
//    NSMutableArray* redArr = [NSMutableArray arrayWithCapacity:0];
//    for (int i = 0; i < 4; i++) {
//        CKRedPacketDataSource* DS = [CKRedPacketDataSource new];
//        DS.balance = (i + 1) * 100;
//        DS.fid = [NSString stringWithFormat:@"id%zi%zi",i,i];
//        DS.is_select_option = (i == 0);
//        DS.name = [NSString stringWithFormat:@"红包%zi",i + 1];
//        [redArr addObject:DS];
//    }
//    
//    CKPayChannelDataSource* vip = [CKPayChannelDataSource new];
//    vip.account_type_id = 999;
//    vip.account_type_nm = @"vip服务";
//    vip.isVipChannel = YES;
////    [vip setIsVipChannel:NO];
//
//    
//
//    
////    [self setAvailableChannelList:arr VIPChannelSource:vip onlyRedPacketChannelSource:nil];
////    [self setRedPacketList:redArr];
//    
//    
//    
//}

/* 设置可用渠道列表 */

- (void) setAvailableChannelList:(NSArray<id<CKPaychannelDataInterface>>*)channelList
                VIPChannelSource:(id<CKPaychannelDataInterface>)vipChannelData
                   redPacketList:(NSArray<id<CKRedPacketDataSourceInterface>>*)redPacketList
                     totalAmount:(long long)amount{
    
    self.channelFilter.channelDataSource = channelList;
    self.channelFilter.vipPayChannelSource = vipChannelData;
    
    if (redPacketList && redPacketList.count > 0) {
        self.redPacketFilter.redSource = redPacketList;
        CKPayChannelDataSource* onlyRedChannel = [CKPayChannelDataSource new];
        onlyRedChannel.account_type_id = 0;
        onlyRedChannel.account_type_nm = @"";
        onlyRedChannel.is_default_option = NO;
        onlyRedChannel.balanceStr = @"";
        onlyRedChannel.lowest_pay_amount = 0;
        onlyRedChannel.highest_pay_amount = 0;
        onlyRedChannel.need_real_name = NO;
        onlyRedChannel.need_pay_pwd = YES;
        onlyRedChannel.need_card_bin = NO;
        self.channelFilter.onlyRedPayChannelSource = onlyRedChannel;
    }
    
    [self.channelFilter initChannel];
    
    self.totalAmount = amount;
}



- (void)setTotalAmount:(long long)totalAmount {
    
    if (_totalAmount == totalAmount) return;
    
    _totalAmount = totalAmount;
    
    //开始计算
    [self startFilter];
}

- (void) startFilter {
    
    _needPayAmount = _totalAmount;
    
    if (_redPacketFilter) {
        if (_redPacketFilter.electedRedPacketStatus) {
            id<CKRedPacketDataSourceInterface> red = [_redPacketFilter.sourceRedPacketDictionary objectForKey:_redPacketFilter.cntSelectRedFid];
            _needPayAmount -= [red redPacketBalance];
            if (_needPayAmount < 0) _needPayAmount = 0;
        }
    }
   
    BOOL ret = [self.channelFilter setPayAmount:_needPayAmount];
    if (!ret) {
        if ([self.delegate respondsToSelector:@selector(flowFilterFinish)]) {
            [self.delegate flowFilterFinish];
        }
    }

    
}


- (void)redPacketFinishFilter:(CKRedPacketFilter *)filte {
    
     [self startFilter];
}


- (void)filterFinishWith:(CKPayChannelFilter *)fi {
    
    if ([self.delegate respondsToSelector:@selector(flowFilterFinish)]) {
        [self.delegate flowFilterFinish];
    }
}

#pragma mark - channel public method

- (void)changeChannelId:(NSNumber *)channelId {
    
    self.channelFilter.selectedPayChannelId = channelId;
}

/* 支付渠道UI Source list*/
- (NSArray<id <CKPayChannelUISourceInterface>> *) channelUISource {
    
    if (!_channelFilter) {
        return @[];
    }
    
    NSMutableArray* tmpList = [NSMutableArray arrayWithCapacity:0];
    
    [self.channelFilter.vipPayChannelList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tmpList addObject:[self.channelFilter.channelUIDictionary objectForKey:obj]];
    }];
    
    [self.channelFilter.enablePayChannelList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tmpList addObject:[self.channelFilter.channelUIDictionary objectForKey:obj]];
    }];
    
    [self.channelFilter.unenablePayChannelList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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

- (CKPayChannelVerifyMark* )channelGuidTitle {
    
    
    CKPayChannelVerifyMark* ver = [CKPayChannelVerifyMark new];
    ver.isVIP = ver.isAuthenticate = NO;
    
    CKPayChannelVerifyType type = [CKPayClient checkPayTypeOfChannel:[self selectChannelDataSource]];
    
    if (type & CKPayChannelVerifyTypeVIPService) {
        ver.title = @"联系VIP专属客服";
        ver.subTitle = @"";
        ver.isVIP = YES;
        return ver;
    }
    
    if (type & CKPayChannelVerifyTypeCardFront) {
        ver.title = @"选择银行卡";
        ver.subTitle = @"根据支付方式要求,请先选择银行卡";
        return ver;
    }
    if (type & CKPayChannelVerifyTypeRealName) {
        ver.title = @"去实名认证";
        ver.subTitle = @"根据支付方式要求,请先实名认证";
        ver.isAuthenticate = YES;
        return ver;
    }
    ver.title = @"立即支付";
    ver.subTitle = @"";
    
    return ver;
}



#pragma mark - redPacket public method

- (void)changeRedPacketId:(NSString*)redPacketId {
    
    if (!_redPacketFilter) return;
    
    self.redPacketFilter.cntSelectRedFid = redPacketId;
}

/* 标识是否存在红包 */
- (BOOL) existRedPacket {
    
    return (_redPacketFilter != nil);
}
/* 是否使用红包 */
- (BOOL) isUseRedPacket {
    
    return (_redPacketFilter && _redPacketFilter.electedRedPacketStatus);
    
}
/* 红包列表 UI Source list */
- (NSArray<id <CKRedPacketUISourceInterface>> *) redPacketUISource {
    
    if (!_redPacketFilter) {
        return @[];
    }
    
    NSMutableArray* tmpList = [NSMutableArray arrayWithCapacity:0];
    [self.redPacketFilter.uiList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tmpList addObject:[self.redPacketFilter.uiRedPacketDictionary objectForKey:obj]];
    }];
    return tmpList;
}
/* 红包选择 UI Source */
- (id<CKRedPacketUISourceInterface>) selectRedPacketUISource {
    
    if (!_redPacketFilter) return nil;
    
    return [self.redPacketFilter.uiRedPacketDictionary objectForKey:self.redPacketFilter.cntSelectRedFid];
    
}
/* 红包选择 Data Source */
- (id<CKRedPacketDataSourceInterface>) selectRedPacketDataSource {
    
    if (!_redPacketFilter) return nil;
    
    return [self.redPacketFilter.sourceRedPacketDictionary objectForKey:self.redPacketFilter.cntSelectRedFid];
}


#pragma mark - 


- (CKPayChannelFilter *)channelFilter {
    
    if (!_channelFilter) {
        _channelFilter = [[CKPayChannelFilter alloc] initWithChannelUISource:[CKPayChannelUISource class] delegate:self];
    }
    return _channelFilter;
}

- (CKRedPacketFilter *)redPacketFilter {
    
    if (!_redPacketFilter) {
        _redPacketFilter = [[CKRedPacketFilter alloc] initWithpacketUISource:[CKRedPacketUISource class] delegate:self];
    }
    return _redPacketFilter;
}

@end
