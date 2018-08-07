//
//  CLAPIPersonalCenter.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/23.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLAPIPersonalCenter.h"

/* 
    #name 个人中心获取用户信息
 
    POST
    @Param cmd      user_info_show
    @param token    xxx
 
 */
NSString const *CMD_UserPersonalMessageAPI = @"user_info_show";


/* 
    #name 系统可修改用户头像列表
    
    POST
    @param cmd      user_head_img_list_show
 */
NSString const *CMD_SystemHeadImgListAPI = @"user_head_img_list_show";

/*  
    #name 更新用户头像
 
    POST
    @param cmd          user_head_img_change
    @param token        xxx
    @param head_img_url img url
 */
NSString const *CMD_UpdateHeadImgAPI = @"user_head_img_change";

/* 
    #name 绑定用户信息
 
    POST
    @param cmd          bind_user_real_information
    @param token        xxx
    @param real_name    真实姓名
    @param card_code    身份证号
 
 */
NSString const *CMD_BindUserRealInfoAPI = @"bind_user_real_information";


/* 
    #name  发送手机验证码
 
    POST
    @param cmd send_verify_code
    @param mobile 手机号码
 */
NSString const *CMD_sendVerifyCodeAPI = @"send_verify_code";

/* #name 绑定用户手机号
 
    POST
    @Param cmd      user_mobile_bind
    @Param token    xxx
    @Param mobile   手机号
    @Param verify_code  验证码
 */
NSString const *CMD_BindUserMobileAPI = @"user_mobile_bind";

/* 
    #name   账户流水
 
    POST    
    @Param cmd account_flow_cash_for_show
    @Param token xxx
    @Param account_type_id  1:真钱  0:彩豆
    @Param last_day     列表底部日期(用于加载更多) <可不传>
 */
NSString const *CMD_AccountCashJournalAPI = @"account_flow_cash_for_show";


/* 
    #name   红包列表 
 
    POST
    @param cmd  red_user_list_by_page
    @Param type 0 可用  1不可用
    @Param page 页数
    @param token xxx
 */
NSString const *CMD_RedEnvelopListAPI = @"red_user_list_by_page";

/* 
    #name   红包详情
    
    POST
    @Param cmd  get_red_info
    @Param token xxx
    @Param fid  红包fid
 */
NSString const *CMD_RedEnvelopDetailAPI = @"get_red_info";


/* 
    #name  红包消费详情
 
    POST
    @Param cmd get_red_info_detail
    @Param user_fid  红包消费id
    @Param token    XXX
    @Param last_fid 最后一条消费id (加载更多时使用)
 */

NSString const *CMD_RedEnvelopConsumeAPI = @"get_red_info_detail";

/* 
    #name   红包兑换
 
    POST
    @Param cmd  red_exchange_redeem_code
    @Param token xxx
    @Param redeem_code  红包兑换码
 
 */

NSString const *CMD_RedEnvelopExchangeAPI = @"red_exchange_redeem_code";


/* 
    #name   修改登录密码
    
    POST
    @Param cmd change_pwd
    @Param token xxx
    @Param password     旧密码
    @Param new_password 新密码
    @Param re_new_password  确认密码
 */
NSString const *CMD_ModifyLoginPwdAPI = @"change_pwd";


/*
 #name   修改支付密码
 
 POST
 @Param cmd change_pay_pwd
 @Param token xxx
 @Param pay_pwd     旧密码
 @Param new_pay_pwd 新密码
 @Param re_new_pay_pwd  确认密码
 */
NSString const *CMD_ModifyPayPwdAPI = @"change_pay_pwd";


/* 
    #name   查询指定用户绑卡列表 
 
    POST
    @Param cmd select_channel_info_by_type
    @Param token xxx
    @Param channel_type  绑卡类型 3:银行卡
    @Param type   消费类型  0:支付  1:提现  2:支付＆提现
    @Param account_type_id  渠道id　9:易联   #optional
 */

NSString const *CMD_UserBindBankCardListAPI = @"select_channel_info_by_type";


/* 
    #name 解绑银行卡
 
    POST    
    @Param cmd  modify_channel_info_by_type
    @Param channel_type  卡类型  3:银行卡
    @Param token    xxx
    @Param other<NSDictionary>  卡相关信息
 
 */

NSString const *CMD_UserReliveBankCardAPI = @"modify_channel_info_by_type";



/*
    #name  校验并获取添加银行卡卡信息
    POST
    @Param cmd  get_card_bin_by_bank_card
    @Param token xxx
    @Param card_no  银行卡号
    @Param type   消费类型  0:支付  1:提现  2:支付＆提现
    @Param account_type_id  渠道id　9:易联   #optional
 */

NSString const *CMD_GetBankCardBinInfoAPI = @"get_card_bin_by_bank_card";

/* 
    #name   添加绑定银行卡
    
    POST
    @Param cmd  modify_channel_info_by_type
    @Param token xxx
    @Param mobile 手机号
    @Param verify_code  验证码
    @Param channel_type 
    @Param sub_bank_name    银行卡名称
    @Param bankCardBinDict
 */

NSString const *CMD_BindBankCardAPI = @"modify_channel_info_by_type";




/* 
    #name   验证码登录/注册/第三方授权后登录
 
    POST
    @Param cmd user_login
    @Param mobile 手机号
    @Param verify_code 验证码
    @Param client_type  客户端类型
    @Param channel      渠道号
    @Param login_version  固定 "240"
    @Param password     登录密码   <该字段用于注册时使用>
    @Param re_password 确认登录密码 <该字段用于注册时使用>
    @Param 第三方信息
    @Param 设备信息
 */

NSString const *CMD_LoginOrRegisterAPI = @"user_login";

/* 
    #name   账户密码登录
 
    POST
    @Param cmd check_pwd
    @Param mobile 手机号
    @Param password 密码
    @Param client_type
    @Param channel      渠道号
    @Param login_version  固定 "240"
    @Param 设备信息
 */

NSString const *CMD_LoginOfPasswordAPI = @"check_pwd";


/* 
    #name 红包购买列表
    
    POST
    @Param cmd get_red_constant_list
    @Param token xxx
    @Param new_client 1  //此字段为支持易宝,易连支付
    @Param pay_version     支付版本号
 */


NSString const *CMD_BuyRedEnvelopListAPI = @"get_red_constant_list";


/* 
    #name 用户提现信息列表
 
    POST
    @Param cmd show_list_for_withdraw
    @Param token xxx
    @Param account_type_id  1
 */
NSString const *CMD_ShowListWithdrawAPI = @"show_list_for_withdraw";

/* 
    #name  创建提现订单
 
    POST
    @Param cmd create_order_for_withdraw
    @Param token xxx
    @Param amount   金额
    @Param channel_type
    @Param channel_info;
 */

NSString const *CMD_CreateWithDrawOrderAPI = @"create_order_for_withdraw";


/* 
    #name   用户提现流水记录 
 
    POST
    @Param  cmd user_cash_order_list_withdraw
    @Param token xxx
    @Param last_day  (加载更多 optional)
 */

NSString const *CMD_WithdrawFollowAPI = @"user_cash_order_list_withdraw";


/*
 
    #name
 
    POST
    @Param cmd get_pay_for_list_has_pre_token_cash
    @Param token xxx
    @Param pre_handle_token 支付预支付token
    @Param new_client 该字段是否支持易宝和易连支付
    @Param pay_version 支付版本
 */
NSString const *CMD_orderPayInfoAPI = @"get_pay_for_list_has_pre_token_cash";

@implementation CLAPIPersonalCenter

@end
