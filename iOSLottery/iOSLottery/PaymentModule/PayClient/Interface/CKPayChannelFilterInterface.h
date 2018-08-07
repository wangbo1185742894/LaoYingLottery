//
//  CKPayChannelFilterInterface.h
//  iOSLottery
//
//  Created by 彩球 on 17/4/14.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol CKPaychannelDataInterface <NSObject>

@property (nonatomic, readonly) NSInteger channel_id;   //渠道id
@property (nonatomic, readonly) long long account_balance;
@property (nonatomic, readonly, strong) NSString* channel_name; //渠道名称
@property (nonatomic, readonly, strong) NSString* channel_img;  //渠道icon
@property (nonatomic, readonly, strong) NSString* channel_subName;  //渠道副标题
@property (nonatomic, readonly) BOOL default_option;    //渠道默认选择

@property (nonatomic) BOOL channel_need_pay_pwd;    //需要验证支付密码
@property (nonatomic) BOOL channel_need_real_name;  //需要实名认证
@property (nonatomic) BOOL channel_need_card_bin;   //需要验证卡前置
@property (nonatomic, readonly) NSInteger channel_limit_mix;    //渠道最小支付限额
@property (nonatomic, readonly) NSInteger channel_limit_max;    //渠道最大支付限额

@property (nonatomic, strong, readonly) NSString *url_prefix;   //支付跳转URL
//
@optional
@property (nonatomic) BOOL isVIP;
@property (nonatomic) BOOL configVIP;
@end



@protocol CKPayChannelUISourceInterface <NSObject>

//渠道viewModel配置
- (void)channelViewModelConfigWithSource:(id<CKPaychannelDataInterface>)source;

/* 修改支付渠道被选择状态 */
- (void)changeChannelSelectState:(BOOL)state;

//根据金额判断支付渠道是否可用(区分渠道)  待做  不同渠道根据不同情况设置不同的 不可用状态, 
//- (void)configStateMessageWithSource:(id<CKPaychannelDataInterface>)source;

@property (nonatomic, strong) NSString* channel_state_msg;  //渠道状态信息
@property (nonatomic) BOOL isSelected;                      //是否选择
@property (nonatomic) BOOL usability;                       //是否可用
@property (nonatomic) BOOL onlyShowChannelNm;

@end

@protocol CKPayChannelFilterInterface <NSObject>

@end
