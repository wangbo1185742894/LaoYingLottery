//
//  CLHomeLottTypeModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/8.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

@interface CLHomeLottTypeModel : CLBaseModel

@property (nonatomic, strong) NSString* imgUrl;
@property (nonatomic, strong) NSString* gameEn;
@property (nonatomic, strong) NSString* gameName;
@property (nonatomic, strong) NSString* lottName;
@property (nonatomic, strong) NSString* tips;
@property (nonatomic) BOOL isDel;    //是否可用

@end
