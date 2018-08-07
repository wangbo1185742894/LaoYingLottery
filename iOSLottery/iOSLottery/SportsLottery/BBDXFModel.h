//
//  BBDXFModel.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLBaseModel.h"

@class BBDXF_SP_Model;

@interface BBDXFModel : SLBaseModel

@property (nonatomic, strong) NSString *odds;

@property (nonatomic, strong) BBDXF_SP_Model *sp;

@end

@interface BBDXF_SP_Model : SLBaseModel

@property (nonatomic, strong) NSString *big;

@property (nonatomic, strong) NSString *small;

@end
