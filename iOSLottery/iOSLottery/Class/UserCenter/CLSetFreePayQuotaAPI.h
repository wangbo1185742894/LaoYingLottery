//
//  CLSetFreePayQuotaAPI.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/18.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLCaiqrBusinessRequest.h"

@interface CLSetFreePayQuotaAPI : CLCaiqrBusinessRequest

@property (nonatomic, strong) NSString* free_pay_amount;
@property (nonatomic, strong) NSString* free_pay_status;
@property (nonatomic, strong) NSString *neverNotify;//不再展示
@property (nonatomic, strong) NSString *is_click;//是否点击了右上角的关闭按钮

@end
