//
//  CLAPIBalancing.h
//  iOSLottery
//
//  Created by 彩球 on 17/2/25.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLAPIBalancing : NSObject


@property (nonatomic, strong) NSString* apiUrl;

@property (nonatomic, strong) NSArray* urls;

@property (nonatomic, strong) NSString* privateKey;

- (void) switchKeyUrl;

+ (instancetype)sharedBalancing;

@end
