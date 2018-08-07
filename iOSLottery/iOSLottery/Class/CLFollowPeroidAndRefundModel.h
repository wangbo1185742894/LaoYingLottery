//
//  CLFollowPeroidAndRefundModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/23.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

@interface CLFollowPeroidAndRefundModel : CLBaseModel

@property (nonatomic) NSInteger peroidDone;
@property (nonatomic) NSInteger totalPeriod;
@property (nonatomic) BOOL isShowRefund;

@end
