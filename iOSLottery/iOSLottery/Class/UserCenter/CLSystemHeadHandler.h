//
//  CLSystemHeadHandler.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/23.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLHeadImgViewModel.h"

@interface CLSystemHeadHandler : NSObject

+ (NSArray*) dealingWithSystemHeadImgFromDict:(NSArray*)array;

+ (NSIndexPath *) searchSelectedHeadImg:(NSString*)headUrl FromArray:(NSArray*)array;


@end
