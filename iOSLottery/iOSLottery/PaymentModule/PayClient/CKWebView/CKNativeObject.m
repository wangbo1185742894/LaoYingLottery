//
//  CKNativeObject.m
//  caiqr
//
//  Created by huangyuchen on 2017/5/4.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKNativeObject.h"

@implementation CKNativeObject

-(void)share:(id)info
{
    
    if (self.shareCallBack) {
        self.shareCallBack(info);
    }
    NSLog(@"js调用oc,用户选择分享功能  information: %@", info);
}

-(void)shareToSocial:(id)info
{
    
    if (self.JCshareToSocial) {
        self.JCshareToSocial(info);
    }
    NSLog(@"js调用oc,用户选择分享到圈子功能  information: %@", info);
}

- (void)nativeLogin:(id)info
{
    if (self.JCLoginCallBack) {
        self.JCLoginCallBack(info);
    }
    NSLog(@"js调用oc,用户选择登录功能  information: %@", info);
}


- (void)showBet:(id)info
{
    if (self.JCShowBetCallBack) {
        self.JCShowBetCallBack(info);
    }
    NSLog(@"js调用oc,用户选择展示虚盘投注功能  information: %@", info);
}

- (void)lotteryBet:(id)info
{
    if (self.JCShowLotteryBetCallBack) {
        self.JCShowLotteryBetCallBack(info);
    }
    NSLog(@"js调用oc,用户选择展示真票投注功能  information: %@", info);
}

- (void)quickPayment:(id)info
{
    if (self.JCQuickPaymentCallBack) {
        self.JCQuickPaymentCallBack(info);
    }
    NSLog(@"js调用oc,快速投注功能  information: %@", info);
}

- (void)jumpNativeIntent:(id)info
{
    if (self.JCJumpNativeIntent) {
        self.JCJumpNativeIntent(info);
    }
    NSLog(@"js调用oc,通用客户端跳转  information: %@", info);
}

- (void)nativeSynUserToken:(id)info
{
    if (self.JCSynLoginCallBack) {
        self.JCSynLoginCallBack(info);
    }
    NSLog(@"js调用oc,同步客户端登陆 information: %@", info);
}

- (void)openLocationPay:(id)info {
    
    if (self.JCNativePaymentCallBack) {
        self.JCNativePaymentCallBack(info);
    }
}







//4.0直播
- (void)onItemClick:(id)info{
    
    if (self.onItemClick && info != nil) {
        self.onItemClick(info);
    }
    NSLog(@"js调用oc,直播条目点击 information: %@", info);
}
- (void)onExamineClick:(id)info{
    if (self.onExamineClick && info != nil) {
        self.onExamineClick(info);
    }
    NSLog(@"js调用oc,查看更多直播 information: %@", info);
}
- (void)setLiveTitle:(id)info{
    if (self.setLiveTitle && info != nil) {
        self.setLiveTitle(info);
    }
    NSLog(@"js调用oc,直播情况描述 information: %@", info);
}
- (void)totalLength:(id)info{
    if (self.totalLength && info != nil) {
        self.totalLength(info);
    }
    NSLog(@"js调用oc,直播模块高度 information: %@", info);
}
- (void)setMaxNumber:(id)info{
    if (self.setMaxNumber && info != nil) {
        self.setMaxNumber(info);
    }
    NSLog(@"js调用oc,最大展示条目 information: %@", info);
}

- (void)setNoNet:(id)info{
    if (self.setNoNet) {
        self.setNoNet(info);
    }
    NSLog(@"js调用oc,加载失败 information: %@", info);
}

- (void)setNoData:(id)info{
    if (self.setNoData) {
        self.setNoData(info);
    }
    NSLog(@"js调用oc,直播无数据 information: %@", info);
}

@end
