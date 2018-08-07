//
//  CLSFCOrderMatchModel.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/30.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

@interface CLSFCOrderMatchModel : CLBaseModel

@property (nonatomic, strong) NSString *awayName;

@property (nonatomic, strong) NSString *hostName;

@property (nonatomic, strong) NSString *matchId;

@property (nonatomic, strong) NSString *betOption;

@property (nonatomic, strong) NSString *result;

@property (nonatomic, assign) NSInteger *serialNumber;


@end
