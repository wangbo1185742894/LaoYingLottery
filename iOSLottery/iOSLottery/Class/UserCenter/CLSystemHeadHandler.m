//
//  CLSystemHeadHandler.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/23.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLSystemHeadHandler.h"
#import <UIKit/UIKit.h>


@implementation CLSystemHeadHandler

+ (NSArray*) dealingWithSystemHeadImgFromDict:(NSArray*)array {
    
    NSArray* result = [CLHeadImgTypeViewModel mj_objectArrayWithKeyValuesArray:array];
    
    
    return result;
}

+ (NSIndexPath *) searchSelectedHeadImg:(NSString*)headUrl FromArray:(NSArray*)array {
    
     NSIndexPath* __block tempIndexPath = nil;
    [array enumerateObjectsUsingBlock:^(CLHeadImgTypeViewModel* typeModel, NSUInteger idxContent, BOOL * _Nonnull stop) {
        
        [typeModel.img_list enumerateObjectsUsingBlock:^(CLHeadImgViewModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.img_url isEqualToString:headUrl])
            {
                tempIndexPath = [NSIndexPath indexPathForRow:idx inSection:idxContent];
                *stop = YES;
            }
        }];
    }];
    if (!tempIndexPath) {
        return nil;
    }
    ((CLHeadImgViewModel *)(((CLHeadImgTypeViewModel *)array[tempIndexPath.section]).img_list[tempIndexPath.row])).selectStatus = YES;
    return tempIndexPath;
}

@end
