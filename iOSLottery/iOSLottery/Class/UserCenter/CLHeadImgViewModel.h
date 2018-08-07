//
//  CLHeadImgViewModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/23.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

@interface CLHeadImgViewModel : CLBaseModel

@property (nonatomic, strong) NSString* img_url;
@property (nonatomic, assign) NSInteger img_id;
@property (nonatomic, assign) NSInteger is_default;
@property (nonatomic, readwrite) BOOL selectStatus;

@end


@interface CLHeadImgTypeViewModel : CLBaseModel

@property (nonatomic, strong) NSMutableArray* img_list;
@property (nonatomic, strong) NSString* img_type_name;
@property (nonatomic, assign) NSInteger img_type;

@end
