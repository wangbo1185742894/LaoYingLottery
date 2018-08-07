//
//  CQFreeOfpayModel.h
//  caiqr
//
//  Created by 洪利 on 2017/3/13.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CLBaseModel.h"

@interface CQFreeOfpayModel : CLBaseModel
/*
 "payment password": 1,  #用户是否设置支付密码 1:是,0:否
 "open_mini_password": 0, #用户是否开启小额免密 1:是,0:否
 "free_pay_pwd_quota": 100,  #用户小额免密额度
 "same_month": 1,  #用户是否在点击关闭提示框同一个月 1:是,0:否
 "never_notify": 0, #用户是否点击不再提醒 1:是,0:否
 "default_quota_list": [
 "100",
 "1000"
 ],
 "default_check_quota" : 100,
 */


@property (nonatomic, strong) NSString *word;
//@property (nonatomic, assign) int payment_password;
@property (nonatomic, assign) int open_mini_password;
@property (nonatomic, strong) NSArray<NSString *> *default_quota_list;
@property (nonatomic, assign) int never_notify;
@property (nonatomic, assign) int is_show;
@property (nonatomic, assign) int same_month;
@property (nonatomic, strong) NSArray<NSString *> *default_quota;
@property (nonatomic, assign) int free_pay_pwd_quota;

@end
