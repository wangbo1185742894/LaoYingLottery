//
//  CLRechargeModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

@interface CLRechargeModel : CLBaseModel

@property (nonatomic, strong) NSMutableArray* channel_list;
@property (nonatomic, strong) NSArray* fill_list;
@property (nonatomic, strong) NSArray *big_moneny;
@property (nonatomic, strong) NSString *template_value;

@end
