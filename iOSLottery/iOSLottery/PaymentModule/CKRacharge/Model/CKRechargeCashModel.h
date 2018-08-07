//
//  CKRechargeCashModel.h
//  caiqr
//
//  Created by 任鹏杰 on 2017/4/28.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKBaseModel.h"

@interface CKRechargeCashModel : CKBaseModel

/**
 显示的金额
 */
@property (nonatomic, strong) NSString* show_name;

/**
 实际金额
 */
@property (nonatomic) long amount_value;

/**
 是否是默认值
 */
@property (nonatomic) BOOL is_default;

@end
