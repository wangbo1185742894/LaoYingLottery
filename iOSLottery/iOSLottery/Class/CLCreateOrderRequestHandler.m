//
//  CLCreateOrderRequestHandler.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/20.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLCreateOrderRequestHandler.h"
#import "CLLotteryCreateOrderRequset.h"
#import "CLLotteryChaseOrderRequest.h"
#import "CLNewLotteryBetInfo.h"
#import "CLLoadingAnimationView.h"
@interface CLCreateOrderRequestHandler () <CLRequestCallBackDelegate>

@property (nonatomic, strong) CLLotteryCreateOrderRequset *normalOrderRequest;
@property (nonatomic, strong) CLLotteryChaseOrderRequest *chaseOrderRequset;

@end
@implementation CLCreateOrderRequestHandler

- (void)createOrderRequestWithType:(NSString *)lotteryGameEn{
    
    CLNewLotteryBetInfo *betInfo = [CLNewLotteryBetInfo shareLotteryBetInfo];
    NSInteger chasePeriod = [betInfo getPeriodWithLottery:lotteryGameEn];
    if (chasePeriod > 1) {
        //有追号
        self.chaseOrderRequset.gameId = [betInfo getGameIdWithLottery:lotteryGameEn];
        self.chaseOrderRequset.lotteryNumber = [betInfo getOrderBetNumberWithLottery:lotteryGameEn];
        self.chaseOrderRequset.amount = [NSString stringWithFormat:@"%zi", [betInfo getMultipleWithLottery:lotteryGameEn] * [betInfo getAllNoteWithLottery:lotteryGameEn] * [betInfo getPeriodWithLottery:lotteryGameEn] * 2];
        if ([betInfo getIsAdditionalWithLottery:lotteryGameEn]) {
            self.chaseOrderRequset.gameExtra = @"ZHUIJIA";
            self.chaseOrderRequset.amount = [NSString stringWithFormat:@"%zi", [betInfo getMultipleWithLottery:lotteryGameEn] * [betInfo getAllNoteWithLottery:lotteryGameEn] * [betInfo getPeriodWithLottery:lotteryGameEn] * 3];
        }
        
        self.chaseOrderRequset.followMode = [betInfo getFollowModeWithLottery:lotteryGameEn];
        self.chaseOrderRequset.followType = [betInfo getFollowTypeWithLottery:lotteryGameEn];
        self.chaseOrderRequset.periodTimesStr = [NSString stringWithFormat:@"%@_%zi", [betInfo getPeriodIdWithLottery:lotteryGameEn], [betInfo getMultipleWithLottery:lotteryGameEn]];
        self.chaseOrderRequset.totalPeriod = [NSString stringWithFormat:@"%zi", [betInfo getPeriodWithLottery:lotteryGameEn]];
        [[CLLoadingAnimationView shareLoadingAnimationView] showLoadingAnimationInCurrentViewControllerWithType:CLLoadingAnimationTypeNormal];
        [self.chaseOrderRequset start];
    }else{
        self.normalOrderRequest.gameId = [betInfo getGameIdWithLottery:lotteryGameEn];
        self.normalOrderRequest.periodId = [betInfo getPeriodIdWithLottery:lotteryGameEn];
        self.normalOrderRequest.betTimes = [NSString stringWithFormat:@"%zi", [betInfo getMultipleWithLottery:lotteryGameEn]];
        self.normalOrderRequest.lotteryNumber = [betInfo getOrderBetNumberWithLottery:lotteryGameEn];
        self.normalOrderRequest.gameExtra = @"";
        self.normalOrderRequest.amount = [NSString stringWithFormat:@"%zi", [betInfo getMultipleWithLottery:lotteryGameEn] * [betInfo getAllNoteWithLottery:lotteryGameEn] * [betInfo getPeriodWithLottery:lotteryGameEn] * 2];
        if ([betInfo getIsAdditionalWithLottery:lotteryGameEn]) {
            self.normalOrderRequest.gameExtra = @"ZHUIJIA";
            self.normalOrderRequest.amount = [NSString stringWithFormat:@"%zi", [betInfo getMultipleWithLottery:lotteryGameEn] * [betInfo getAllNoteWithLottery:lotteryGameEn] * [betInfo getPeriodWithLottery:lotteryGameEn] * 3];
        }
        [[CLLoadingAnimationView shareLoadingAnimationView] showLoadingAnimationInCurrentViewControllerWithType:CLLoadingAnimationTypeNormal];
        [self.normalOrderRequest start];
    }
    
}
#pragma mark ------------ delefate ------------
- (void)requestFinished:(CLBaseRequest *)request{
    
    if (!request.urlResponse.resp || !request.urlResponse.success) {
        
        if ([self.delegate respondsToSelector:@selector(requestFailWithOrderInfo:)]) {
            [self.delegate requestFailWithOrderInfo:request.urlResponse.errorMessage];
        }
        [[CLLoadingAnimationView shareLoadingAnimationView] stop];
        return;
    }

    if ([self.delegate respondsToSelector:@selector(requestFinishWithOrderInfo:)]) {
        [self.delegate requestFinishWithOrderInfo:request.urlResponse.resp];
    }
    [[CLLoadingAnimationView shareLoadingAnimationView] stop];
}
- (void)requestFailed:(CLBaseRequest *)request{
    
    if ([self.delegate respondsToSelector:@selector(requestFailWithOrderInfo:)]) {
        [self.delegate requestFailWithOrderInfo:request.urlResponse.errorMessage];
    }
    [[CLLoadingAnimationView shareLoadingAnimationView] stop];
}


#pragma mark ------------ getter Mothed ------------
- (CLLotteryCreateOrderRequset *)normalOrderRequest{
    
    if (!_normalOrderRequest) {
        _normalOrderRequest = [[CLLotteryCreateOrderRequset alloc] init];
        _normalOrderRequest.delegate = self;
    }
    return _normalOrderRequest;
}
- (CLLotteryChaseOrderRequest *)chaseOrderRequset{
    
    if (!_chaseOrderRequset) {
        _chaseOrderRequset = [[CLLotteryChaseOrderRequest alloc] init];
        _chaseOrderRequset.delegate = self;
    }
    return _chaseOrderRequset;
}

@end
