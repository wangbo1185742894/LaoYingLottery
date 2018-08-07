//
//  CKPayMentInfoModel.h
//  caiqr
//
//  Created by huangyuchen on 2017/4/27.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKBaseModel.h"
@class CKPayHandleModel;

@interface CKPayMentInfoModel : CKBaseModel

@property (nonatomic, strong) CKPayHandleModel *pre_handle_token;
@property (nonatomic, strong) NSMutableArray *account_infos;
@property (nonatomic, strong) NSArray *default_account;
@property (nonatomic, strong) NSArray *red_list;
@property (nonatomic, strong) NSArray *big_moneny;

@end
