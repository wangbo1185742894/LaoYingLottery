//
//  BBSFCModel.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLBaseModel.h"

@class BBSFC_SP_Model;

@interface BBSFCModel : SLBaseModel

@property (nonatomic, strong) BBSFC_SP_Model *sp;

@end

@interface BBSFC_SP_Model : SLBaseModel

@property (nonatomic, strong) NSString *host_1_5;

@property (nonatomic, strong) NSString *host_6_10;

@property (nonatomic, strong) NSString *host_11_15;

@property (nonatomic, strong) NSString *host_16_20;

@property (nonatomic, strong) NSString *host_21_25;

@property (nonatomic, strong) NSString *host_26;

@property (nonatomic, strong) NSString *away_1_5;

@property (nonatomic, strong) NSString *away_6_10;

@property (nonatomic, strong) NSString *away_11_15;
@property (nonatomic, strong) NSString *away_16_20;
@property (nonatomic, strong) NSString *away_21_25;

@property (nonatomic, strong) NSString *away_26;


@end
