//
//  CLSFCSelectedModel.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/27.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLSFCSelectedModel.h"

@implementation CLSFCSelectedModel

- (NSMutableArray *)optionsArray
{

    if (_optionsArray == nil) {
        
        _optionsArray = [NSMutableArray new];
    }
    return _optionsArray;
}

@end
