//
//  CLHomeAPIModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/8.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

@interface CLHomeAPIModel : CLBaseModel

@property (nonatomic, strong) NSArray* banners;
@property (nonatomic, strong) NSArray* hotGamePeriods;
@property (nonatomic, strong) NSArray* reports;
@property (nonatomic, strong) NSArray* gameEntrances;
@property (nonatomic, strong) NSString *gamesEntranceCn;
@property (nonatomic, strong) NSString *attentionEntranceCn;
@property (nonatomic, strong) NSArray *attentionEntrances;

@end
