//
//  BBSFModel.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLBaseModel.h"

@class BBSF_SP_Model;

@interface BBSFModel : SLBaseModel

@property (nonatomic, strong) BBSF_SP_Model *sp;

@end

@interface BBSF_SP_Model : SLBaseModel

@property (nonatomic, strong) NSString *win;

@property (nonatomic, strong) NSString *loss;

@end
