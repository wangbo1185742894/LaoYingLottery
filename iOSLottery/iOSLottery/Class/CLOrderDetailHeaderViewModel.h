//
//  CLOrderDetailHeaderViewModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/17.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLOrderDetailHeaderViewModel : NSObject

@property (nonatomic, strong) NSString* gameEn;
@property (nonatomic, strong) NSString* lotteryName;
@property (nonatomic, strong) NSString* lotteryPeriod;

@property (nonatomic, strong) NSMutableArray* lineArrays;
@property (nonatomic, strong) NSMutableArray* dotArrays;
@property (nonatomic, strong) NSMutableArray* basicArrays;

@property (nonatomic, strong) NSString* lotteryStoreName;


@end
