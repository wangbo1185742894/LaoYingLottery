//
//  CKNativeObject.h
//  caiqr
//
//  Created by huangyuchen on 2017/5/4.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JavaScriptCore/JavaScriptCore.h>

typedef void(^JCCallBack)(id info);


@protocol NativeObjectExport <JSExport>

- (void)share:(id )info;

- (void)shareToSocial:(id)info;

- (void)nativeLogin:(id)info;

- (void)showBet:(id)info;

- (void)lotteryBet:(id)info;

- (void)quickPayment:(id)info;

- (void)jumpNativeIntent:(id)info;

- (void)nativeSynUserToken:(id)info;

- (void)openLocationPay:(id)info;




//4.0直播
- (void)onItemClick:(id)info;
- (void)onExamineClick:(id)info;
- (void)setLiveTitle:(id)info;
- (void)totalLength:(id)info;
- (void)setMaxNumber:(id)info;
- (void)setNoNet:(id)info;
- (void)setNoData:(id)info;

@end

@interface CKNativeObject : NSObject<NativeObjectExport>

@property (nonatomic, copy) JCCallBack shareCallBack;

@property (nonatomic, copy) JCCallBack JCshareToSocial;

@property (nonatomic, copy) JCCallBack JCLoginCallBack;

@property (nonatomic, copy) JCCallBack JCShowBetCallBack;

@property (nonatomic, copy) JCCallBack JCShowLotteryBetCallBack;

@property (nonatomic, copy) JCCallBack JCQuickPaymentCallBack;

@property (nonatomic, copy) JCCallBack JCJumpNativeIntent;

@property (nonatomic, copy) JCCallBack JCSynLoginCallBack;

@property (nonatomic, copy) JCCallBack JCNativePaymentCallBack;




//4.0 直播
@property (nonatomic, copy) JCCallBack onItemClick;
@property (nonatomic, copy) JCCallBack onExamineClick;
@property (nonatomic, copy) JCCallBack setLiveTitle;
@property (nonatomic, copy) JCCallBack totalLength;
@property (nonatomic, copy) JCCallBack setMaxNumber;
@property (nonatomic, copy) JCCallBack setNoNet;
@property (nonatomic, copy) JCCallBack setNoData;


@end
