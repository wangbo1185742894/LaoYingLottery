//
//  CLRedEnveDetaModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/29.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

@interface CLRedEnveDetaModel : CLBaseModel

@property (nonatomic, strong) NSString *red_balance;
@property (nonatomic, strong) NSArray *red_table;
@property (nonatomic, assign) BOOL red_status;
@property (nonatomic, strong) NSDictionary *red_button;

@end
