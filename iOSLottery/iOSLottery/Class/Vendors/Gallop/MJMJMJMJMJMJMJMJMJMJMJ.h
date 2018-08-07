//
//  MJMJMJMJMJMJMJMJMJMJMJ.h
//  MJSports
//
//  Created by 彩球 on 2018/3/24.
//  Copyright © 2018年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDWebImageManager.h"

@interface MJMJMJMJMJMJMJMJMJMJMJ : NSObject

@property (nonatomic,assign,getter = isCancelled) BOOL cancelled;
@property (nonatomic,copy) SDWebImageNoParamsBlock cancelBlock;
@property (nonatomic,strong) NSOperation* cacheOperation;

@end
