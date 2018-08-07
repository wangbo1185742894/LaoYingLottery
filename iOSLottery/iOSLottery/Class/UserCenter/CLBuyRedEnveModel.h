//
//  CLBuyRedEnveModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/12.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

@interface CLBuyRedEnveModel : CLBaseModel

@property (nonatomic, strong) NSArray* channel_list;
@property (nonatomic, strong) NSString*  red_custom_program_id;
@property (nonatomic, strong) NSArray* red_list;

@end
