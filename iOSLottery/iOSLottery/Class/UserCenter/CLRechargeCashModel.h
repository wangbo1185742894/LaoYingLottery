//
//  CLRechargeCashModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

@interface CLRechargeCashModel : CLBaseModel

@property (nonatomic, strong) NSString* show_name;
@property (nonatomic) long amount_value;
@property (nonatomic) BOOL is_default;

@end
