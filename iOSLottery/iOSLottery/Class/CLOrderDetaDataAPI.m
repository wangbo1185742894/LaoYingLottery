//
//  CLOrderDetaDataAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLOrderDetaDataAPI.h"

@interface CLOrderDetaDataAPI () <CLBaseConfigRequest>

@end

@implementation CLOrderDetaDataAPI

- (NSString *)methodName {
    
    return @"CLOrderDetailData";
}

- (NSString *)requestBaseUrlSuffix {
    
    return @"/order/detail";
}

@end
