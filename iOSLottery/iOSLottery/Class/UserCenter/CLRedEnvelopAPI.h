//
//  CLRedEnvelopAPI.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/28.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLCaiqrBusinessRequest.h"

@class CQUserRedPacketsNewModel;

@protocol CLRedEnvelopAPIGetDataInterface <NSObject>

- (void)configureRedEnveListDataFromDict:(NSDictionary*)dict;

- (CQUserRedPacketsNewModel *) redEnvelistData;

- (void) refresh;

- (void) nextPage;

- (BOOL) canLoadingMore;

@end

typedef NS_ENUM(NSInteger, redEnveLoadType) {
    
    redEnveLoadTypeAvailable,
    redEnveLoadTypeUnavailable,
};

@interface CLRedEnvelopAPI : CLCaiqrBusinessRequest <CLRedEnvelopAPIGetDataInterface>

@property (nonatomic) redEnveLoadType listType;

@property (nonatomic) BOOL canLoadingMore;

- (void) nextPage;


@end
