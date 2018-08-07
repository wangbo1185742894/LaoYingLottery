//
//  CKFOPModel.h
//  caiqr
//
//  Created by 洪利 on 2017/4/27.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKBaseModel.h"

@interface CKFOPModel : CKBaseModel
@property (nonatomic, strong) NSString *word;

@property (nonatomic, assign) int open_mini_password;
@property (nonatomic, strong) NSArray<NSString *> *default_quota_list;
@property (nonatomic, assign) int never_notify;
@property (nonatomic, assign) int is_show;
@property (nonatomic, assign) int same_month;
@property (nonatomic, strong) NSArray<NSString *> *default_quota;
@property (nonatomic, assign) int free_pay_pwd_quota;
@end
