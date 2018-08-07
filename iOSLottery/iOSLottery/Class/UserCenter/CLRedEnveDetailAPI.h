//
//  CLRedEnveDetailAPI.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/29.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLCaiqrBusinessRequest.h"

@class CLRedEnveDetaModel;

@interface CLRedEnveDetailAPI : CLCaiqrBusinessRequest

@property (nonatomic, strong) NSString* fid;

- (void)configureDetailInfoFromDict:(NSDictionary*)dict;

- (CLRedEnveDetaModel*)pullDetailData;

@end
