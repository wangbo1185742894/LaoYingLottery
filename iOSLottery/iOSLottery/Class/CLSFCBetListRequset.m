//
//  CLSFCBetListRequset.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/26.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLSFCBetListRequset.h"

@interface CLSFCBetListRequset ()

@property (nonatomic, strong) NSArray *dataArray;



@end

@implementation CLSFCBetListRequset

- (NSString *)requestBaseUrlSuffix
{

    return [NSString stringWithFormat:@"/bet/sfcMatches/%@",self.gameEn];
}

@end
