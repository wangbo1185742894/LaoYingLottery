//
//  CLSFCSelectedModel.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/27.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

@interface CLSFCSelectedModel : CLBaseModel

@property (nonatomic, strong) NSString *matchId;

@property (nonatomic, strong) NSMutableArray *optionsArray;

@end
