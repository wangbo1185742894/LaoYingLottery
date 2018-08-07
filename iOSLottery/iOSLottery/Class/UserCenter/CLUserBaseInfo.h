//
//  CLUserBaseInfo.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/6.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class UserInfo,AccountInfo,LoginToken;

@interface CLUserBaseInfo : NSObject

@property (nonatomic, strong) AccountInfo* account_info;
@property (nonatomic, strong) LoginToken* login_token;
@property (nonatomic, strong) UserInfo* user_info;

@end


@interface UserInfo : NSObject

@property (nonatomic, strong) NSString* create_time;
@property (nonatomic, strong) NSString* card_code;
@property (nonatomic, strong) NSString* channel_id;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSString* client_type;
@property (nonatomic, strong) NSString* country;
@property (nonatomic, strong) NSString* user_id;
@property (nonatomic, strong) NSString* device_id;
@property (nonatomic, strong) NSString* device_name;
@property (nonatomic, strong) NSString* device_token;
@property (nonatomic, strong) NSString* head_img_url;
@property (nonatomic, strong) NSString* mobile;
@property (nonatomic, strong) NSString* nick_name;
@property (nonatomic, strong) NSString* oauth_id;
@property (nonatomic, strong) NSString* partner_id;
@property (nonatomic, strong) NSString* province;
@property (nonatomic, strong) NSString* sex;
@property (nonatomic, strong) NSString* status;
@property (nonatomic, strong) NSString* third_id;
@property (nonatomic, strong) NSString* update_time;
@property (nonatomic, strong) NSString* wx_id;
@property (nonatomic, strong) NSString* real_name;
@property (nonatomic, strong) NSString* card_image_url_front;
@property (nonatomic, strong) NSString* card_image_url_back;
@property (nonatomic, assign) long long free_pay_pwd_quota; //免额金额
@property (nonatomic, readwrite) BOOL free_pay_pwd_status;  //免额状态
@property (nonatomic, readwrite) BOOL has_pwd;  //用户是否设置字符串密码
@property (nonatomic, readwrite) BOOL has_pay_pwd;
@property (nonatomic, readwrite) BOOL isVip;        //是不是会员 预留字段
@property (nonatomic, readwrite) BOOL isAdmin;      //是不是管理员

@end


@interface AccountInfo : NSObject

+ (AccountInfo*)attribute:(id)info;
@property (nonatomic, assign) double account_balance;
@property (nonatomic, assign) double red_balance;

@end


@interface LoginToken : NSObject

@property (nonatomic, strong) NSString* token;

@end





