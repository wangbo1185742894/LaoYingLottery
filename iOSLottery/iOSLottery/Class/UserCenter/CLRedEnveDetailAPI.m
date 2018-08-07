//
//  CLRedEnveDetailAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/29.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLRedEnveDetailAPI.h"
#import "CLAPI.h"
#import "CLRedEnveDetaModel.h"
#import "CLAppContext.h"

@interface CLRedEnveDetailAPI () <CLBaseConfigRequest>

@property (nonatomic, strong) CLRedEnveDetaModel* detailData;

@end

@implementation CLRedEnveDetailAPI

- (NSString *)methodName {
    
    return @"get_red_info";
}

- (NSDictionary *)requestBaseParams {
    
    return @{@"cmd":CMD_RedEnvelopDetailAPI,
             @"token":[[CLAppContext context] token],
             @"fid":self.fid};
}


- (void)configureDetailInfoFromDict:(NSDictionary*)dict {
    
    self.detailData = [CLRedEnveDetaModel mj_objectWithKeyValues:dict];
}

- (CLRedEnveDetaModel*)pullDetailData {
    
    return self.detailData;
}

@end
