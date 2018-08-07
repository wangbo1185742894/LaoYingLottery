//
//  CLHomeBannerModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/8.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"



@interface CLHomeBannerModel : CLBaseModel

@property (nonatomic) NSInteger actionType;
@property (nonatomic) NSInteger bannerId;
@property (nonatomic, strong) NSString* detailUrl;
@property (nonatomic, strong) NSString* imgUrl;
@property (nonatomic, strong) NSString* title;
@property (nonatomic) NSInteger weight;

@end
